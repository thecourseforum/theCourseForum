$(function() {

    var raw = $('#percentages').data().percents,

        baseColors = {
            a: '#223165',
            b: '#15214B',
            c: '#0F1932',
            d: '#EE5F35',
            f: '#D75626',
            drop: '#C14927',
            withdraw: '#5A6D8E',
            other: '#5A6D8E'
        },

        labelColors = {
            'aplus': {
                color: Highcharts.Color(baseColors['a']).brighten(0.3).get(),
                text: 'A+'
            },
            'a': {
                color: Highcharts.Color(baseColors['a']).brighten(0.2).get(),
                text: 'A'
            },
            'aminus': {
                color: Highcharts.Color(baseColors['a']).brighten(0.1).get(),
                text: 'A-'
            },
            'bplus': {
                color: Highcharts.Color(baseColors['b']).brighten(0.3).get(),
                text: 'B+'
            },
            'b': {
                color: Highcharts.Color(baseColors['b']).brighten(0.2).get(),
                text: 'B'
            },
            'bminus': {
                color: Highcharts.Color(baseColors['b']).brighten(0.1).get(),
                text: 'B-'
            },
            'cplus': {
                color: Highcharts.Color(baseColors['c']).brighten(0.3).get(),
                text: 'C+'
            },
            'c': {
                color: Highcharts.Color(baseColors['c']).brighten(0.2).get(),
                text: 'C'
            },
            'cminus': {
                color: Highcharts.Color(baseColors['c']).brighten(0.1).get(),
                text: 'C-'
            },
            'dplus': {
                color: Highcharts.Color(baseColors['d']).brighten(0.3).get(),
                text: 'D+'
            },
            'd': {
                color: Highcharts.Color(baseColors['d']).brighten(0.2).get(),
                text: 'D'
            },
            'dminus': {
                color: Highcharts.Color(baseColors['d']).brighten(0.1).get(),
                text: 'D-'
            },
            'f': {
                color: Highcharts.Color(baseColors['f']),
                text: 'F'
            },
            'drop': {
                color: Highcharts.Color(baseColors['drop']),
                text: 'Drop'
            },
            'withdraw': {
                color: Highcharts.Color(baseColors['withdraw']),
                text: 'Withdraw'
            },
            'other': {
                color: Highcharts.Color(baseColors['other']),
                text: 'Other'
            }
        }

    var data = $.map(raw, function(percentage, grade) {
        if (grade == 'gpa' || grade == 'total') {
            return {}
        } else {
            return {
                name: labelColors[grade]['text'],
                y: Math.round((percentage * 100)),
                color: labelColors[grade]['color']
            }
        }
    });

    data.pop();
    data.pop();

    console.log(data);

    // // Otherwise build the gradewheel
    if (raw.gpa) {
        // Create the chart
        $('.course-grades').highcharts({
            chart: {
                type: 'pie',
                height: 390,
            },
            title: {
                verticalAlign: 'middle',
                text: raw.gpa.toFixed(2) + " GPA",
                style: {
                    fontFamily: 'HelveticaNeue-Medium',
                    fontSize: '24px'
                },
                //aligns the title to center the two lines
                y: 1
            },
            subtitle: {
                verticalAlign: 'middle',
                text: raw.total + " students",
                style: {
                    fontFamily: 'Lato',
                    fontSize: '16px',
                    marginTop: '10px',
                },
                y: 20,
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
            series: [{
                name: '',
                data: data,
                size: '100%',
                innerSize: '60%',
                dataLabels: {
                    formatter: function() {
                        return this.y > 5 ? this.point.name : null;
                    },
                    color: 'white',
                    style: {
                        fontFamily: 'Lato',
                        fontSize: '16px'
                    },
                    distance: -31

                }
            }]
        });

    } else {
        $('.course-grades').highcharts({
            chart: {
                type: 'pie',
                height: 390,
            },
            colors: ['#90A6CF'],
            title: {
                verticalAlign: 'middle',
                text: 'We have no grades' + '<br>' + ':(',
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
            tooltip: false,
            credits: false,
            series: [{
                name: '',
                data: [{
                    name: ":(",
                    y: 100.00
                }, ],
                size: '100%',
                innerSize: '60%',
                dataLabels: {
                    formatter: function() {
                        return null;
                    },
                    color: 'white',
                    style: {
                        fontFamily: 'Lato',
                        fontSize: '16px'
                    },
                    distance: -31
                }
            }]
        });
    }
});