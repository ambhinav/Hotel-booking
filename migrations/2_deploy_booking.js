const HotelBooking = artifacts.require("HotelBooking");

module.export = function(deployer) {
    deployer.deploy(HotelBooking);
}