    var data = [
        {
            value: '{$data.open}',
            color:"Red",
            highlight: "#FF5A5E",
            label: "Open Gaps"
        },
        {
            value: '{$data.closed}',
            color:"Green",
            highlight: "#5AD3D1",
            label: "Closed Gaps"
        }
    ];
    (new Chart($("#{$layer}").get(0).getContext("2d")).Pie(data,options));
