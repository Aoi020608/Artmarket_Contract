const Auction = artifacts.require("Auction");
const ArtToken = artifacts.require("ArtToken");
const Crowdfunding = artifacts.require("Crowdfunding");

const auctionSetting = {
    biddingTime: Date.now(),
}

module.exports = async function (deployer, network, account) {

    deployer.deploy(Auction);

    await deployer.deploy(ArtToken, "Art NFT", "ANFT");
    
    deployer.deploy(Crowdfunding);
};
