    var data = [
        {
            value: '{$data.readable}',
            color:"Green",
            highlight: "#5AD3D1",
            label: "Readable"
        },
        {
            value: '{$data.nonreadable}',
            color:"Blue",
            highlight: "#FFC870",
            label: "Un-readable"
        }
    ];
    (new Chart($("#{$layer}").get(0).getContext("2d")).Pie(data,options));

