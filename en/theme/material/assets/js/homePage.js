function getSelectedValue() {
    const baseURl = "http://localhost:8000/migration/docs";
    var select = document.getElementById("apim-version-1");
    var selectedValue = select.options[select.selectedIndex].value;

    let VersionfNumber = selectedValue.match(/(\d+)/);
    console.log("Selected value" , VersionfNumber[0]);

    var Sselect = document.getElementById("apim-version-2");
    var SselectedValue = Sselect.options[Sselect.selectedIndex].value;
    let VersionsNumber = SselectedValue.match(/(\d+)/);


    if (VersionsNumber[0] == 440) {
      if (VersionfNumber[0] == 430) {
        console.log("Selected Sucesssfully");
      } else {
        console.log("You Need to upgrade 430 version for upgrade to 440");
      }
    } else if (VersionfNumber[0] < VersionsNumber[0]) {
        window.open(`./apim-revamped/migration-catalog/upgrading-to-apim-${VersionsNumber[0]}/upgrading-from-${VersionfNumber[0]}-to-${VersionsNumber[0]}/config-migration`, '_blank');
        // window.location.href = "./apim-revamped/migration-catalog/upgrading-to-apim-420/upgrading-to-apim-420"
      console.log("Selected Sucesssful");
    } else {
      console.log("error,Please check the versions");
    }
  }