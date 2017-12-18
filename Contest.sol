pragma solidity ^0.4.11;
// We have to specify what version of compiler this code will compile with

contract Voting {
  /* mapping field below is equivalent to an associative array or hash.
  The key of the mapping is candidate name stored as type bytes32 and value is
  an unsigned integer to store the vote count
  */
  
  mapping (bytes32 => uint8) votesReceived;
  
  /* Solidity doesn't let you pass in an array of strings in the constructor (yet).
  We will use an array of bytes32 instead to store the list of candidates
  */
  mapping(address => uint8) OneTimeVote;
  bytes32[]  candidateList;
 string[] public CandidateList;

  /* This is the constructor which will be called once when you
  deploy the contract to the blockchain. When we deploy the contract,
  we will pass an array of candidates who will be contesting in the election
  */
 
  function stringToBytes32(string memory source) private returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
        return 0x0;
    }

    assembly {
        result := mload(add(source, 32))
    }
}
   function bytes32ToString(bytes32 x) private constant returns (string) {
    bytes memory bytesString = new bytes(32);
    uint charCount = 0;
    for (uint j = 0; j < 32; j++) {
        byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
        }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (j = 0; j < charCount; j++) {
        bytesStringTrimmed[j] = bytesString[j];
    }
    return string(bytesStringTrimmed);
} 

  function addCandidate(string name) public{
      CandidateList.push(name);
      candidateList.push( stringToBytes32(name));
     
  }

  // This function returns the total votes a candidate has received so far
  function totalVotesFor(string candidate) view public returns (uint8) {
    bytes32 candidate1=stringToBytes32(candidate);
    require(validCandidate(candidate));
    return votesReceived[candidate1];
  }
    
  // This function increments the vote count for the specified candidate. This
  // is equivalent to casting a vote
  function voteForCandidate(string candidate) public {
    bytes32 candidate1=stringToBytes32(candidate);
    require(validCandidate(candidate));
    require(OneTimeVote[msg.sender]!=1);
    votesReceived[candidate1] += 1;
    OneTimeVote[msg.sender]=1;
  }

  function validCandidate(string candidate) view public returns (bool) {
     bytes32 candidate1=stringToBytes32(candidate);
    for(uint i = 0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate1) {
        return true;
      }
    }
    return false;
  }
 
  function winningCandidate() view public returns (string) {
      uint max=0;uint ind=100;
      for(uint i=0; i<candidateList.length;i++ )
      {
          if(votesReceived[candidateList[i]]>max)
          {
              max=votesReceived[candidateList[i]];
              ind=i;
          }
      }
      return bytes32ToString(candidateList[ind]);
      
  }
}
