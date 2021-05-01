import React from "react"
import PropTypes from "prop-types"

import CoursePieChart from "./CoursePieChart"


export default class CoursePage extends React.Component {
  
  constructor(props) {
    super(props);
    this.buildRatingsCard = this.buildRatingsCard.bind(this);
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
  
  /**
  * Format the ratings information
  */
  buildRatingsCard() {
    
    let ratings = this.props.ratings;
    let overall = (ratings.overall ? ratings.overall : "--");
    let professorRating = (ratings.prof ? ratings.prof : "--");
    
    return (
      <div className="ratings-block">
        <div className="row">
          <div className="col">
            <div className="overall-value">
              {overall}
            </div>
            <div className="overall-label">
              Overall Rating 
            </div>
          </div>
          <div className="col">
            <div className="overall-value">
              {professorRating}
            </div>
            <div className="overall-label">
              Professor Rating 
            </div>
          </div>
        </div>
      </div>
    );
  }
  
  render () {
    if (this.state.course == null) {
      return <h1>Loading...</h1>
    }
    
    let ratingsCard = this.buildRatingsCard.call();

    return (
      <React.Fragment>
        <div className="course-ratings-container">
          <div className="col">
            <CoursePieChart graph_data={this.props.graph_data}/>
          </div>
          <div className="col">
            {ratingsCard}
          </div>
        </div>
      </React.Fragment>
    );
  }
}
