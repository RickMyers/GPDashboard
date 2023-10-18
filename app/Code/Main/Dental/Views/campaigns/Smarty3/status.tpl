    
    var data = [
        {
            value: {$results->campaignContactsCompleted()},
            color:"Red",
            highlight: "#FF5A5E",
            label: "Completed"
        },
        {
            value: {$results->campaignContactsDeclined()},
            color:"Navy",
            highlight: "#5A5EFF",
            label: "Declined"
        },        
        {
            value: {$schedule->campaignInProgressContacts()},
            color:"Green",
            highlight: "#5AD3D1",
            label: "In-Progress"
        },
        {
            value: {$schedule->campaignQueuedContacts()},
            color:"Blue",
            highlight: "#FFC870",
            label: "Queued"
        },
        {
            value: {$schedule->campaignUnassignedContacts()},
            color:"Teal",
            highlight: "#C8FF70",
            label: "Unassigned"
        }
    ];
    (new Chart($("#{$layer}").get(0).getContext("2d")).Pie(data,options));