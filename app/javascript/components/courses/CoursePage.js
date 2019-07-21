import React from "react"
import PropTypes from "prop-types"

import CoursePieChart from "./CoursePieChart"


export default class CoursePage extends React.Component {
  
  constructor(props) {
    super(props);
    this.state = {
      course: null
    }
  }
  
  /**
  * On component mount, fetch json of the current course
  * Update state.
  */
  componentDidMount = () => {
    let routeLink = '/courses/' + this.props.course_id + '/professors.json';
    fetch(routeLink)
      .then((response) => {
        return response.json();
      })
      .then((json) => {
        this.setState({
          course: json
        })
      });
  }
  
  render () {
    if (this.state.course == null) {
      return <h1>Loading...</h1>
    }

    return (
      <React.Fragment>
        <div className="content">
          <div className="wheelGraph">
            <CoursePieChart
              graph_data={this.props.graph_data}
            />
          </div>
        </div>
      </React.Fragment>
    );
  }
}
