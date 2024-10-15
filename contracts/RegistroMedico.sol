// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

contract HealthcareRegistro {
    address proprietario;

    struct Registro {
        uint256 registroID;
        string pacienteNome;
        string diagnostico;
        string tratamento;
        uint256 timestamp;
    }

    mapping(uint256 => Registro[]) private registroPaciente;

    mapping(address => bool) private provedorAutorizado;
    
    modifier somenteProprietario() {
        require(msg.sender == proprietario, "Somente o proprietario pode utilizar essa funcao");
        _;
    }

    modifier somenteProvedorAutorizado() {
        require(provedorAutorizado[msg.sender], "Provedor nao autorizado");
        _;
    }

    constructor() {
        proprietario = msg.sender;
    } 

    function getProprietario() public view returns (address) {
        return proprietario;
    }

    function autorizarProvedor(address provider) public somenteProprietario {
        provedorAutorizado[provider] = true;
    }


    function addRegistro(uint256 pacienteID, string memory pacienteNome, string memory diagnostico, string memory tratamento) public somenteProprietario{
        uint256 registroID = registroPaciente[pacienteID].length +1;
        registroPaciente[pacienteID].push(Registro(registroID, pacienteNome, diagnostico, tratamento, block.timestamp));
    }

    function getRegistroPaciente(uint256 pacienteID) public view somenteProvedorAutorizado returns (Registro[] memory) {
        return registroPaciente[pacienteID];
    }

}

//0x4b227ba6b037af5a079791e279e091e5d6ddc1c8