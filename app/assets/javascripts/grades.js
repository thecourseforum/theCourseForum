$(function () {

    var grades = gon.grades;  
    var percentages = gon.percentages;
    var colors = ['#223165', '#15214B', '#0F1932', '#EE5F35', '#D75626', '#C14927','#5A6D8E','#9F9F9F'],

        categories = ['A\'s', 'B\'s', 'C\'s', 'D\'s', 'Other'],
        // categories: ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'Drop', 'F', 'WD', 'Other'],

        //Breaks percentages up by letter, then drilled down by plus or minus
        data = [{ 
        	//A's
            y: Math.round(100*(percentages.aplus + percentages.a + percentages.aminus)), //overall percentage
            color: colors[0],
            drilldown: {
                name: 'A dist',
                categories: ['A+', 'A', 'A-'],
                data: [Math.round(100*percentages.aplus), Math.round(100*percentages.a), Math.round(100*percentages.aminus)], //A+, A, A-
                color: colors[0]
            }
        }, {
        	//B's
            y: Math.round(100*(percentages.bplus + percentages.b + percentages.bminus)),
            color: colors[1],
            drilldown: {
                name: 'B dist',
                categories: ['B+', 'B', 'B-'],
                data: [Math.round(100*percentages.bplus), Math.round(100*percentages.b), Math.round(100*percentages.bminus)],
                color: colors[1]
            }
        }, {
        	//C's
            y: Math.round(100*(percentages.cplus + percentages.c + percentages.cminus)),
            color: colors[2],
            drilldown: {
                name: 'C dist',
                categories: ['C+', 'C', 'C-'],
                data: [Math.round(100*percentages.cplus), Math.round(100*percentages.c), Math.round(100*percentages.cminus)],
                color: colors[2]
            }
        }, {
        	//D's
            y: Math.round(100*(percentages.dplus + percentages.d+ percentages.dminus)),
            color: colors[3],
            drilldown: {
                name: 'D dist',
                categories: ['D+', 'D', 'D-'],
                data: [Math.round(100*percentages.dplus), Math.round(100*percentages.d), Math.round(100*percentages.dminus)],
                color: colors[3]
            }
        }, {
        	//Other (F's, drops, withdraws, and other)
            y: Math.round(100*(percentages.f + percentages.drop+ percentages.wd + percentages.other)),
            color: colors[4],
            drilldown: {
                name: 'Other',
                categories: ['F', 'Drop', 'Withdraw', 'Other'],
                data: [Math.round(100*percentages.f), Math.round(100*percentages.drop), Math.round(100*percentages.wd), Math.round(100*(percentages.other))],
                color: colors[4]
            }
        }],
        overallLetters = [],
        plusOrMinus = [],
        i,
        j,
        dataLen = data.length,
        drillDataLen,
        brightness;


    // Build the data arrays

    for (i = 0; i < dataLen; i += 1) {

        // add letter data
        overallLetters.push({
            name: categories[i],
            y: data[i].y,
            color: data[i].color
        });

        // add plus or minus data
        drillDataLen = data[i].drilldown.data.length;
        for (j = 0; j < drillDataLen; j += 1) {
            brightness = 0.2 - (j / drillDataLen) / 5;
            plusOrMinus.push({
                name: data[i].drilldown.categories[j],
                y: data[i].drilldown.data[j],
                color: Highcharts.Color(data[i].color).brighten(brightness).get()
            });
        }
    }

    // Create the chart
    $('.col-xs-6.course-grades').highcharts({
        chart: {
            type: 'pie'
        },
        title: {        	
        	verticalAlign: 'middle',
            text: (percentages.gpa).toFixed(2) + " GPA<br/>" +(percentages.total) + " students",
            style: {
            	fontFamily: 'Futura',
            	fontSize: '16px'
            },
            //aligns the title to center the two lines
            y: 1
        },
        yAxis: {
            title: {
                text: ''
            }
        },
        plotOptions: {
            pie: {
                shadow: false,
                center: ['50%', '50%']
            }
        },
        tooltip: {
            pointFormat: '<b>{point.y}</b>', 
            valuePrefix: '',
            valueSuffix: '%'
        },
        series: [
        // This is the inner pie chart with overall letter data 
        // we want a donut so we are hiding this
        // {
        //     name: 'Letters',
        //     data: overallLetters,
        //     size: '50%',
        //     dataLabels: {
        //         formatter: function () {
        //             // return (percentages.gpa);
        //             // return this.y > 5 ? this.point.name : null;
        //         },
        //         color: 'white',
        //         distance: -30
        //     }
        // }, 
        {
            name: '',
            data: plusOrMinus,
            size: '90%',
            innerSize: '60%',
            dataLabels: {
                formatter: function () {
                    return this.y > 5 ? this.point.name : null;
                },
                color: 'white',
                style: {
 					fontFamily: 'Futura', 
                	fontSize: '16px'
                },
                distance: -31

            }           
            
            // dataLabels: {
            //     formatter: function () {
            //         return this.y > 5 ? this.point.name : null;
            //         // display only if larger than 1
            //         // return this.y > 1 ? '<b>' + this.point.name + ':</b> ' + this.y + '%'  : null;
            //     }
            // }
        }]
    }
    //on complete, add GPA and number of students text to the center
    // function(chart) { 
    //     text = chart.renderer.label('<span style="font-size:20px"><b>' + (percentages.gpa).toFixed(2) + " GPA" + "</b></span>").add();        
    //     text2 = chart.renderer.text((percentages.total) + " students").add();
    //     textBBox = text.getBBox();
    //     textBBox2 = text2.getBBox();
    //     x = chart.plotLeft + (chart.plotWidth  * 0.5) - (textBBox.width  * 0.5);
    //     y = chart.plotTop  + (chart.plotHeight * 0.5) - (textBBox.height * 0.5);
    //     text.attr({x: x, y: y});
    //     x2 = chart.plotLeft + (chart.plotWidth  * 0.5) - (textBBox2.width  * 0.5);
    //     y2 = chart.plotTop  + (chart.plotHeight * 0.58) - (textBBox2.height * 0.58);
    //     text2.attr({x: x2, y: y2});
    // });
    );
});
