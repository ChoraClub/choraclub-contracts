// This script can be used to deploy the "Storage" contract using ethers.js library.
// Please make sure to compile "./contracts/1_Storage.sol" file before running this script.
// And use Right click -> "Run" from context menu of the file to run the script. Shortcut: Ctrl+Shift+S

import { deploy } from "./ethers-lib";

(async () => {
  try {
    const result = await deploy("AttesterResolver", [
      "0x4200000000000000000000000000000000000021",
      "0x8dEa0ad941d577e356745d758b30Fa11EFa28E80",
      "0x97861976283e6901b407D1e217B72c4007D9F64D",
    ]);
    console.log(`address: ${result.address}`);
  } catch (e) {
    console.log(e.message);
  }
})();
