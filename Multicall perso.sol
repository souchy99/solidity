//"SPDX-License-Identifier: UNLICENSED"
pragma solidity >0.6.0 <0.9.0;

interface UniswapFunctions{
    function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function token0() external view returns (address);
    function token1() external view returns (address);
}

contract MultiCallSacha{

    function priceMulticall(address[] memory addresses) external view returns(uint112[] memory,uint112[] memory){
        uint112[] memory array0 = new uint112[](addresses.length);
        uint112[] memory array1 = new uint112[](addresses.length);
        for(uint112 i = 0; i < addresses.length; i++){
            (uint112 reserve0, uint112 reserve1,) = UniswapFunctions(addresses[i]).getReserves();
            array0[i] = reserve0;
            array1[i] = reserve1;
        }
        return (array0,array1);
    }

    function tokenMulticall(address[] memory Lp) external view returns(address[] memory,address[] memory){
        address[] memory array0 = new address[](Lp.length);
        address[] memory array1 = new address[](Lp.length);
        for(uint112 i = 0; i < Lp.length; i++){
            array0[i] = UniswapFunctions(Lp[i]).token0();
            array1[i] = UniswapFunctions(Lp[i]).token1();
        }
        return (array0,array1);
    }

    function getPairMulticall(address[] memory tokenA,address[] memory tokenB) external view returns(address[] memory){
        require(tokenA.length == tokenB.length,"Merci d'envoyer le meme nombre de token de chaque cote ! ");
        address[] memory pairs = new address[](tokenA.length);
        for(uint112 i = 0; i < tokenA.length; i++){
            //on met comme contract le factory de pancake
            address pancakeFactory = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;
            pairs[i] = UniswapFunctions(pancakeFactory).getPair(tokenA[i],tokenB[i]);
        }
        return (pairs);
    }
    

}