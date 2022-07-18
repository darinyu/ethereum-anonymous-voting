pragma solidity >=0.8.0 <0.9.0;

import "./AnonymousElection.sol";

contract AnonymousElectionCreator {
    // Who is the owner of this election creator?
    // TODO: instantiate the address of the owner of the election.
    address private owner;
    // TODO: create a mapping of the election name string to the election address.
    mapping(string => address) election_address_map;
    // TODO: create an array of strings of the names of elections.
    string[] private electionsList; 

// sets the owner of the election to the one who deploys the smart contract
    

    // Create the constructor.
    constructor() {
        // TO DO: instantiate the "owner" as the msg.sender.
        owner = msg.sender;
        // TO DO: instantiate the election list.
        electionsList = new string[](0);        
    }

    function electionCreated(string memory _a) private view returns (bool) {
        bytes memory thisEmpty;
        return keccak256(abi.encodePacked(election_address_map[_a])) != keccak256(thisEmpty);
    }


    // Write the function that creates the election:
    function createElection(string memory _electionName, string[] memory _candidates, address[] memory _voters, bytes memory _p, bytes memory _g) public returns(address) {
        // make sure that the _electionName is unique
        // TODO: use the solidity require function to ensure the election name is unique. "Election name not unique. An election already exists with that name."
        require(electionCreated(_electionName), "Election name not unique. An election already exists with that name.");

        // TODO: use the solidity require function to ensure "candidate list and voter list both need to have non-zero length, >1 candidate."
        require(_candidates.length>1);
        require(_voters.length>0);        
        // TODO: Using a for loop, require none of the candidates are the empty string.
        for (uint i = 0; i < _candidates.length; i++) {
            bytes memory candidate_bytes = bytes(_candidates[i]); 
            require(candidate_bytes.length > 0);
        }

        // TODO: Create a new election.
        AnonymousElection election = new AnonymousElection(_candidates, _voters, _p, _g, owner, _electionName);

        // TODO: Create a mapping between _electionName and election address.
        election_address_map[_electionName]  = address(election);

        // TODO: Use .push() to add name to electionsList
        electionsList.push(_electionName);

        // TODO: return the address of the election created
        return address(election);
    }

    // return address of an election given the election's name
    function getElectionAddress(string memory _electionName) public view returns(address) {
        // TODO: Using the solidity require function, ensure that _electionName is a valid election.
        require(electionCreated(_electionName), "Election not created yet");

        // TODO: Return the address of requested election.
        return election_address_map[_electionName];
    }

    // return list of all election names created with this election creator
    function getAllElections() public view returns (string[] memory){
        return electionsList;
    }
}
