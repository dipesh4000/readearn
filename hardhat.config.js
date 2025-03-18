require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

module.exports = {
  solidity: "0.8.4",
  networks: {
    educhain: {
      url: "https://rpc.open-campus-codex.gelato.digital",
      chainId: 656476,
      accounts: "8ed05b3fbd205b5309e645504fe257a19886ffdf6b9c1c022263940f900091f3"
    }
  }
};

