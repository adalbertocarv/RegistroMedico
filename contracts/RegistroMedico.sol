// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract HealthcareRegistro {
    address private proprietario;

    // Estrutura para armazenar os registros médicos
    struct Registro {
        uint256 registroID;
        string pacienteNome;
        string diagnostico;
        string tratamento;
        uint256 timestamp;
    }

    // Contador para IDs de pacientes (para auto-incrementar o ID do paciente)
    uint256 private contadorPacienteID;

    // Mapeamento de ID do paciente para a lista de registros
    mapping(uint256 => Registro[]) private registroPaciente;

    // Mapeamento para verificar se o provedor é autorizado
    mapping(address => bool) private provedorAutorizado;

    // Evento para rastrear a adição de novos registros
    event RegistroAdicionado(uint256 indexed pacienteID, uint256 registroID, string pacienteNome);

    // Modificador para garantir que apenas o proprietário execute certas funções
    modifier somenteProprietario() {
        require(msg.sender == proprietario, "Somente o proprietario pode utilizar essa funcao");
        _;
    }

    // Modificador para garantir que apenas provedores autorizados acessem certas funções
    modifier somenteProvedorAutorizado() {
        require(provedorAutorizado[msg.sender], "Provedor nao autorizado");
        _;
    }

    // O construtor define o criador do contrato como o proprietário
    constructor() {
        proprietario = msg.sender;
    } 

    // Função que retorna o endereço do proprietário
    function getProprietario() public view returns (address) {
        return proprietario;
    }

    // Função para autorizar um provedor de saúde
    function autorizarProvedor(address provider) public somenteProprietario {
        provedorAutorizado[provider] = true;
    }

    // Função para adicionar um novo registro de paciente (somente proprietário pode chamar)
    function addRegistro(
        string memory pacienteNome, 
        string memory diagnostico, 
        string memory tratamento
    ) 
        public 
        somenteProprietario 
    {
        // Incrementa o contador de pacienteID para cada novo paciente
        contadorPacienteID++;
        
        uint256 pacienteID = contadorPacienteID;
        
        // O ID do registro é baseado na quantidade de registros que o paciente já possui
        uint256 registroID = registroPaciente[pacienteID].length + 1;
        
        // Adiciona o registro do paciente no array de registros
        registroPaciente[pacienteID].push(
            Registro(
                registroID, 
                pacienteNome, 
                diagnostico, 
                tratamento, 
                block.timestamp
            )
        );

        emit RegistroAdicionado(pacienteID, registroID, pacienteNome); // Emitindo evento de adição de registro
    }

    // Função para obter o registro do paciente (somente provedores autorizados podem chamar)
    function getRegistroPaciente(uint256 pacienteID) 
        public 
        view 
        somenteProvedorAutorizado 
        returns (Registro[] memory) 
    {
        return registroPaciente[pacienteID];
    }
}
