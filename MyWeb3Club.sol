// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Counters.sol";
import "./MyWeb3ClubNFT.sol";
contract MyWeb3Club{

    using Counters for Counters.Counter;
    Counters.Counter public _clubIds;
    address clubNFTAddress;
    struct User{
        string avatar;
        string nickname;
        uint[] joinClubs;
    }
    struct Club{
        uint clubId;
        uint category;
        address nftContract;
        string avatar;
        string title;
        string description;
        address creator;
        uint joinCount;
    }
    

    mapping(address=>User) public UsersMapping;
    mapping(uint=>Club) public ClubsMapping;
    mapping(uint=>uint[]) public ClubNFTMapping;
    mapping(uint=>uint[]) public CategoriesMapping;

    constructor(address _clubNFTAddress){
        clubNFTAddress=_clubNFTAddress;
    }


    function createUserInfo(string memory _avatar,string memory _nickname)public {
        uint[] memory joinClubs;   
        if(UsersMapping[msg.sender].joinClubs.length==0){
            joinClubs=new uint[](0);
        }else{
            joinClubs=UsersMapping[msg.sender].joinClubs;
        }
        User memory newUser=User(_avatar,_nickname,joinClubs);
        UsersMapping[msg.sender]=newUser;
    }

    function getUserInfo()public view returns(string memory,string memory){
        return (UsersMapping[msg.sender].avatar,UsersMapping[msg.sender].nickname);
    }


    function createClub(uint _category,address  _nftContract,string memory _avatar,string memory _title,string memory _description)public{
        uint clubId=_clubIds.current();
        Club memory club=Club(clubId,_category,_nftContract,_avatar,_title,_description,msg.sender,0);
        ClubsMapping[clubId]=club;
        CategoriesMapping[_category].push(clubId);
        _clubIds.increment();
    }

    function createNFT(uint clubId,string memory _content,string memory _img)public{
        MyWeb3ClubNFT clubNFT=MyWeb3ClubNFT(clubNFTAddress);
        uint nftId=clubNFT.mintNFT(msg.sender,_content,_img);
        ClubNFTMapping[clubId].push(nftId);
    }

    function joinClub(uint clubId)public{
        UsersMapping[msg.sender].joinClubs.push(clubId);
        ClubsMapping[clubId].joinCount=ClubsMapping[clubId].joinCount+1;
    }

    function quitClub(uint clubId)public{
        uint[] memory joinClubIds=UsersMapping[msg.sender].joinClubs;
        require(joinClubIds.length>0);
        for(uint i=0;i<joinClubIds.length;i++){
            if(clubId==joinClubIds[i]){
                UsersMapping[msg.sender].joinClubs[i] = UsersMapping[msg.sender].joinClubs[joinClubIds.length - 1];
                UsersMapping[msg.sender].joinClubs.pop();
                break;
            }
        }
        ClubsMapping[clubId].joinCount=ClubsMapping[clubId].joinCount-1;
    }

    function getClubNFT(uint _clubId,uint _pageNum,uint _pageSize)public view returns(uint[] memory){
        uint[] memory clubNFTs=ClubNFTMapping[_clubId];
        uint[] memory clubNFTIds=getDataByPage(clubNFTs,_pageNum,_pageSize);
        return clubNFTIds;
    }


    function getCategoriesData(uint categoriesCount) public view returns(uint [] memory){
        uint[] memory categoriesData=new uint[](categoriesCount);
        for(uint i=0;i<categoriesCount;i++){
            categoriesData[i]=CategoriesMapping[i].length;
        }
        return categoriesData;
    }

    function getClubListByCategory(uint category,uint _pageNum,uint _pageSize) public view returns(uint[] memory){
        return getDataByPage(CategoriesMapping[category],_pageNum,_pageSize);
    }

   
    function getDataByPage(uint[] memory _array,uint _pageNum,uint _pageSize)private pure returns(uint[] memory){
   
        uint arrayLength;
        uint arrayIndex=0;
 
        uint dataStart=(_array.length-1) - (_pageNum-1) * _pageSize; 
        uint dataEnd;
        
        if(dataStart<_pageSize){ 
            dataEnd=0;
            arrayLength=dataStart+1;
        }else{
            dataEnd=dataStart-_pageSize+1;
            arrayLength=_pageSize;
        }

        uint[] memory returnArray=new uint[](arrayLength);

        for(int i=int(dataStart);i>=int(dataEnd);i--){
            returnArray[arrayIndex]=_array[uint(i)];
            arrayIndex++;
        }
        return returnArray;
    }



    
    
 


}