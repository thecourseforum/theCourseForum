import React from "react"
import PropTypes from "prop-types"
import Highcharts from "highcharts";
import HighchartsReact from "highcharts-react-official";

export default class CoursePieChart extends React.Component {
  
  constructor(props) {
    super(props);
    this.formatGraphData = this.formatGraphData.bind(this);
    this.getLabelColors = this.getLabelColors.bind(this);
    this.getOptions = this.getOptions.bind(this);
  }
  
  /**
  * Function converts raw course gpa data into a "Highchart" friendly format
  */
  formatGraphData(labelColors) {
    
    var formattedData = [];
    let rawData = Object.entries(this.props.graph_data);
    
    for (const entry in rawData) {
      let letterGrade = rawData[entry][0];
      let percentReceived = rawData[entry][1];
      
      // gpa and total have no labelColors
      if (letterGrade !== 'gpa' && letterGrade !== 'total') {
        let letterGradeFormatted = labelColors[letterGrade]["text"];
        let color = labelColors[letterGrade]["color"];
        
        // build JSON object (name, color, y) are special keywords
        let json_data = {
          name: letterGradeFormatted,
          color: color,
          y: Math.round((percentReceived * 100)),
        }
        
        formattedData.push(json_data);
        
      }
    }
    
    console.log(formattedData);
    return formattedData;
  }
  
  /**
  * Defines the relationship between our SQL data and our desired graph format
  */
  getLabelColors() {
    
    let labelColors = {
      'aplus': {
          color: Highcharts.Color('#4D5F9A').brighten(0.03).get(),
          text: 'A+'
      },
      'a': {
          color: Highcharts.Color('#4D5F9A').brighten(0.025).get(),
          text: 'A'
      },
      'aminus': {
          color: Highcharts.Color('#4D5F9A').brighten(0.02).get(),
          text: 'A-'
      },
      'bplus': {
          color: Highcharts.Color('#344377').brighten(0.01).get(),
          text: 'B+'
      },
      'b': {
          color: Highcharts.Color('#344377').brighten(0.005).get(),
          text: 'B'
      },
      'bminus': {
          color: Highcharts.Color('#344377').get(),
          text: 'B-'
      },
      'cplus': {
          color: Highcharts.Color('#15214B').brighten(0.01).get(),
          text: 'C+'
      },
      'c': {
          color: Highcharts.Color('#15214B').brighten(0.005).get(),
          text: 'C'
      },
      'cminus': {
          color: Highcharts.Color('#15214B').get(),
          text: 'C-'
      },
      'dplus': {
          color: Highcharts.Color('#EE5F35').brighten(0.01).get(),
          text: 'D+'
      },
      'd': {
          color: Highcharts.Color('#EE5F35').brighten(0.005).get(),
          text: 'D'
      },
      'dminus': {
          color: Highcharts.Color('#EE5F35').get(),
          text: 'D-'
      },
      'f': {
          color: Highcharts.Color('#D75626').get(),
          text: 'F'
      },
      'drop': {
          color: Highcharts.Color('#C14927').get(),
          text: 'Drop'
      },
      'withdraw': {
          color: Highcharts.Color('#C14927').get(),
          text: 'Withdraw'
      },
      'other': {
          color: Highcharts.Color('#9f9f9f').get(),
          text: 'Other'
      }
    }
    
    return labelColors;
  }
  
  /**
  * Builds and returns the options required to construct the Highchart
  */
  getOptions(formattedData) {
    
    let gradeDataExists = (this.props.graph_data["gpa"] != null);
    
    let options = {
      chart: {
        type: "pie",
        height: 400,
      },
      colors: (gradeDataExists ? [] : ['#90A6CF']),
      title: {
        text: (gradeDataExists ? this.props.graph_data["gpa"].toFixed(2) + " GPA" : "We have no grades" + "<br>" + ":("),
        verticalAlign: 'middle',
        style: {
            fontFamily: 'HelveticaNeue-Medium',
            fontSize: (gradeDataExists ? '24px' : '16px')
        },
        //aligns the title to center the two lines
        y: 1,
      },
      subtitle: {
          verticalAlign: 'middle',
          text: (gradeDataExists ? this.props.graph_data["total"] + " students" : ""),
          style: {
              fontFamily: 'Lato',
              fontSize: '16px',
              marginTop: '10px',
          },
          y: 20,
      },
      yAxis: {
        title: {
          text: '',
        }
      },
      plotOptions: {
        pie: {
          shadow: false,
          center: ['50%', '50%'],
        }
      },
      tooltip: (gradeDataExists ? {pointFormat: '<b>{point.y}</b>', valuePrefix: '', valueSuffix: '%'} : false),
      credits: false,
      series: [
        {
          name: '',
          size: '100%',
          innerSize: '60%',
          data: (gradeDataExists ? formattedData : [{name: ":(", y: 100.00},]),
          dataLabels: {
              formatter: function() {
                if (gradeDataExists) {
                    return this.y > 5 ? this.point.name : null;
                }
                else {
                  return null;
                }
              },
              style: {
                  fontFamily: 'Lato',
                  fontSize: '16px'
              },
              color: 'white',
              distance: -30,
          },
        }
      ]
    }
    
    return options;
  }

  render() {
    
    const labelColors = this.getLabelColors.call();
    const formattedData = this.formatGraphData.call(this, labelColors);
    const options = this.getOptions.call(this, formattedData);
    
    return (
      <HighchartsReact highcharts={Highcharts} options={options} />
    );
  }
}
