$(function() {

    // Get the array of course/professor ids that correspond to the grade graph element ids
    IDs = $('#IDs').data('ids');    
    numIDs = 0;
    // This assignment determines whether to build the stacked bar graph on each course/section
    // or just the grade wheel for a single section

    // If IDs was passed in, then it defined and there are that many courses/sections
    if (typeof IDs != 'undefined') {        
        numIDs = IDs.length;

    // Otherwise, we are on the course page
    } else {
        // and there is only 1 section
        numIDs = 1;
        // and one element with id suffix = 0
        var IDs = [0];
    }

    // Initialize vars
    var colors = ['#223165', '#15214B', '#0F1932', '#EE5F35', '#D75626', '#C14927', '#5A6D8E', '#9F9F9F'],
        categories = ["A's", "B's", "C's", "D's", "Other"];

    // Put each course's percentage data into an array of all of them
    allCoursePercentages = [];
    for (var i = 0; i < numIDs; i++) {
        allCoursePercentages.push($('#percentages-' + IDs[i]).data('percents'))
    }    

    // Iterate through each one to build the graph data for each course
    for (var i = 0; i < numIDs; i++) {           
        // console.log("i is",i);
        //Breaks percentages up by letter, then drilled down by plus or minus
        data = [{
            //A's
            y: Math.round(100 * (allCoursePercentages[i].aplus + allCoursePercentages[i].a + allCoursePercentages[i].aminus)), //overall percentage
            color: colors[0],
            drilldown: {
                name: 'A dist',
                categories: ['A+', 'A', 'A-'],
                data: [Math.round(100 * allCoursePercentages[i].aplus), Math.round(100 * allCoursePercentages[i].a), Math.round(100 * allCoursePercentages[i].aminus)], //A+, A, A-
                color: colors[0]
            }
        }, {
            //B's
            y: Math.round(100 * (allCoursePercentages[i].bplus + allCoursePercentages[i].b + allCoursePercentages[i].bminus)),
            color: colors[1],
            drilldown: {
                name: 'B dist',
                categories: ['B+', 'B', 'B-'],
                data: [Math.round(100 * allCoursePercentages[i].bplus), Math.round(100 * allCoursePercentages[i].b), Math.round(100 * allCoursePercentages[i].bminus)],
                color: colors[1]
            }
        }, {
            //C's
            y: Math.round(100 * (allCoursePercentages[i].cplus + allCoursePercentages[i].c + allCoursePercentages[i].cminus)),
            color: colors[2],
            drilldown: {
                name: 'C dist',
                categories: ['C+', 'C', 'C-'],
                data: [Math.round(100 * allCoursePercentages[i].cplus), Math.round(100 * allCoursePercentages[i].c), Math.round(100 * allCoursePercentages[i].cminus)],
                color: colors[2]
            }
        }, {
            //D's
            y: Math.round(100 * (allCoursePercentages[i].dplus + allCoursePercentages[i].d + allCoursePercentages[i].dminus)),
            color: colors[3],
            drilldown: {
                name: 'D dist',
                categories: ['D+', 'D', 'D-'],
                data: [Math.round(100 * allCoursePercentages[i].dplus), Math.round(100 * allCoursePercentages[i].d), Math.round(100 * allCoursePercentages[i].dminus)],
                color: colors[3]
            }
        }, {
            //Other (F's, drops, withdraws, and other)
            y: Math.round(100 * (allCoursePercentages[i].f + allCoursePercentages[i].drop + allCoursePercentages[i].wd + allCoursePercentages[i].other)),
            color: colors[4],
            drilldown: {
                name: 'Other',
                categories: ['F', 'Drop', 'Withdraw', 'Other'],
                data: [Math.round(100 * allCoursePercentages[i].f), Math.round(100 * allCoursePercentages[i].drop), Math.round(100 * allCoursePercentages[i].wd), Math.round(100 * (allCoursePercentages[i].other))],
                color: colors[4]
            }
        }];
        overallLetters = [];
        plusOrMinus = [];
        dataLen = data.length;
        var drillDataLen;
        var brightness;


        // Build the data arrays
        for (j = 0; j < dataLen; j += 1) {

            // add letter data
            overallLetters.push({
                name: categories[j],
                y: data[j].y,
                color: data[j].color
            });

            // add plus or minus data
            drillDataLen = data[j].drilldown.data.length;
            for (n = 0; n < drillDataLen; n += 1) {
                brightness = 0.2 - (j / drillDataLen) / 5;
                plusOrMinus.push({
                    name: data[j].drilldown.categories[n],
                    y: data[j].drilldown.data[n],
                    color: Highcharts.Color(data[j].color).brighten(brightness).get()
                });
            }
        }

        // If displaying graphs for each course,
        if (IDs[0] != 0) {
            // Build the data for the stacked bar graph
            var stackedGraphDataSeries = [];
            for (m = overallLetters.length - 1; m >= 0; m--) {
                stackedGraphData = {};
                stackedGraphData.name = overallLetters[m].name;
                stackedGraphData.data = [overallLetters[m].y];
                stackedGraphData.color = overallLetters[m].color;
                stackedGraphData.y = overallLetters[m].y;

                stackedGraphData.dataLabels = {
                        enabled: true,
                        inside: true,
                        color: 'white',
                        formatter: function() {
                            return this.y > 3 ? this.series.name : null;
                        },
                        style: {
                            fontFamily: 'Futura',
                            fontSize: '16px'
                        }
                    }
                    // {
                    //     formatter: function () {
                    //             return this.y > 5 ? this.point.name : null;
                    //             // display only if larger than 1
                    //             // return this.y > 1 ? '<b>' + this.point.name + ':</b> ' + this.y + '%'  : null;
                    //     }
                    // }
                stackedGraphDataSeries.push(stackedGraphData);

            }


            // Create the chart
            try {
                $('#grade-bar-' + IDs[i]).highcharts({
                    chart: {
                        type: 'bar',
                        margin: 0
                    },
                    title: {
                        text: ''
                    },
                    xAxis: {
                        gridLineWidth: 0,
                        enabled: true,
                        lineWidth: -1,
                        categories: [''],
                        labels: {
                            enabled: true
                        },

                    },
                    yAxis: {
                        enabled: true,
                        gridLineWidth: 0,
                        lineWidth: 0,
                        min: 0,
                        title: {
                            text: '',
                            margin: 0
                        },
                        labels: {
                            enabled: true
                        }
                    },
                    legend: {
                        enabled: false,
                    },
                    tooltip: {
                        formatter: function() {
                            return this.y > 3 ? '' + this.y + '%' : this.series.name + ': ' + this.y + '%';
                        }
                    },
                    credits: {
                        enabled: false,
                        position: {
                            align: 'left',
                            x: 10
                        }
                    },
                    plotOptions: {
                        series: {
                            stacking: 'percent',
                            pointPadding: 0,
                            groupPadding: 0
                        }
                    },
                    series: stackedGraphDataSeries,
                    exporting: {
                        enabled: false
                    }
                });
                $('.highcharts-axis').css('display', 'none');
            } catch (error) {

            }
        }
        // Otherwise build the gradewheel
        else {
            // Create the chart
            $('.course-grades').highcharts({
                chart: {
                    type: 'pie',                    
                    height: 380,
                },
                title: {
                    verticalAlign: 'middle',
                    text: (allCoursePercentages[i].gpa).toFixed(2) + " GPA<br/>" + (allCoursePercentages[i].total) + " students",
                    style: {
                     fontFamily: 'Lato',
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
                credits: false,
                series: [
                    // This is the inner pie chart with overall letter data 
                    // we want a donut so we are hiding this
                    // {
                    //     name: 'Letters',
                    //     data: overallLetters,
                    //     size: '50%',
                    //     dataLabels: {
                    //         formatter: function () {
                    //             // return (allCoursePercentages[i].gpa);
                    //             // return this.y > 5 ? this.point.name : null;
                    //         },
                    //         color: 'white',
                    //         distance: -30
                // This is the inner pie chart with overall letter data 
                // we want a donut so we are hiding this
                // {
                //     name: 'Letters',
                //     data: overallLetters,
                //     size: '50%',
                //     dataLabels: {
                //         formatter: function () {
                //             // return (allCoursePercentages[i].gpa);
                //             // return this.y > 5 ? this.point.name : null;
                //         },
                //         color: 'white',
                //         distance: -30
                //     }
                // }, 
                {
                    name: '',
                    data: plusOrMinus,
                    size: '100%',
                    innerSize: '60%',
                    dataLabels: {
                        formatter: function () {
                            return this.y > 5 ? this.point.name : null;
                        },
                        color: 'white',
                        style: {
                         fontFamily: 'Lato',
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
                    // },                             
                }
                ]
            });

        }

    }



});
