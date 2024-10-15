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

    

}