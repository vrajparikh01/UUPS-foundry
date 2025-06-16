// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console}  from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract UpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("owner");
    address public proxy;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();

        proxy = deployer.run(); // returns the address of the proxy and not the implementation
    }

    function testDeploymentBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setValue(42);
    }

    function testUpgrade() public {
        BoxV2 box2 = new BoxV2();
        
        upgrader.upgradeBox(proxy, address(box2));

        uint256 expectedVersion = 2;
        assertEq(BoxV2(proxy).version(), expectedVersion);

        BoxV2(proxy).setValue(42);
        assertEq(BoxV2(proxy).getValue(), 42);
    }
}