pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";
  
  //Store Posts
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );
  
  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  //Create Posts
  function uploadImage(string memory _imgHash, string memory _description) public {
    // Make sure image values exits
    require(bytes(_imgHash).length > 0);
    require(bytes(_description).length > 0);
    require(msg.sender != address(0x0));

    // Increment Image id
    imageCount ++;

    // Add Image to contract
    images[imageCount] = Image(imageCount , _imgHash, _description, 0, msg.sender);

    // Trigger an event
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);


  }

  //Tip Posts

  function tipImageOwner(uint _id) public payable {
    // Make sure that ID is correct
    require(_id > 0 && _id <= imageCount);
    // Fetch Image
    Image memory _image = images[_id];
    
    // Fetch the author
    address payable _author = _image.author;

    // Pay the author
    _author.transfer(msg.value);

    // Increment the tip amount
    _image.tipAmount = _image.tipAmount + msg.value;

    // Update the image
    images[_id] = _image;

    // Trigger an event
     emit ImageTipped(imageCount, _image.hash, _image.description, _image.tipAmount, _author);
  }
}