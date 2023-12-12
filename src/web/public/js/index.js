//var title = document.getElementById("title").cloneNode(true);
//var items = document.getElementById("items").cloneNode(true);
//var homePage = document.getElementById('home-page').cloneNode(true);
//var cashStatsPage = document.getElementById('cash-stats-page');

function show(name){
    const body = document.getElementById("body");
    // bodyChildren.length-2 so we don't modify the <script> node 
    for(var i = 0; i < body.childNodes.length-2; i++){
        if (body.childNodes[i].nodeName === "DIV"){
            body.childNodes[i].style.visibility = "hidden";
            body.childNodes[i].style.display = "none";
            if (body.childNodes[i].id === name){
                body.childNodes[i].style.visibility = "visible";
                body.childNodes[i].style.display = "block";
            }
        }
    }

}

function displayHomePage(){
    show("home-page");
}

function displayCashPage(){
    show("cash-stats-page");
}

function displayCameraPage(){
    show('camera-page');
}

function displaySoundsPage(){
    show('sounds-page');
}

function displayBlankPage(){
    show('blank-page');
}

function displayTrainPage(){
    show('train-page');
}

function displaySettingsPage(){
    show('settings-page');
}

function displayMattPage(){
    show('MATT-page');
}

/* Home click listeners */

document.getElementById("cash-stats-button").addEventListener("click", function(){
    console.log("cash stats button clicked");
    displayCashPage();
});

document.getElementById("on-off-button").addEventListener("click", function(){
    console.log("on off button clicked");
});

document.getElementById("camera-button").addEventListener("click", function(){
    console.log("camera button clicked");
    displayCameraPage();
});

document.getElementById("sounds-button").addEventListener("click", function(){
    console.log("sounds button clicked");
    displaySoundsPage();
});

document.getElementById("blank-button").addEventListener("click", function(){
    console.log("blank button clicked");
    displayBlankPage();
});

document.getElementById("train-button").addEventListener("click", function(){
    console.log("train button clicked");
    displayTrainPage();
});

document.getElementById("settings-button").addEventListener("click", function(){
    console.log("settings button clicked");
    displaySettingsPage();
});

document.getElementById("MATT-button").addEventListener("click", function(){
    console.log("MATT button clicked");
    displayMattPage();
});

/* return Home button click listerns */
document.getElementById("cash-home-button").addEventListener("click", function(){
    console.log("cash stats home button clicked");
    displayHomePage();
});

document.getElementById("camera-home-button").addEventListener("click", function(){
    console.log("camera home button clicked");
    displayHomePage();
});

document.getElementById("sounds-home-button").addEventListener("click", function(){
    console.log("sounds home button clicked");
    displayHomePage();
});
document.getElementById("blank-home-button").addEventListener("click", function(){
    console.log("blank home button clicked");
    displayHomePage();
});
document.getElementById("train-home-button").addEventListener("click", function(){
    console.log("train home button clicked");
    displayHomePage();
});
document.getElementById("settings-home-button").addEventListener("click", function(){
    console.log("settings home button clicked");
    displayHomePage();
});
document.getElementById("MATT-home-button").addEventListener("click", function(){
    console.log("MATT home button clicked");
    displayHomePage();
});