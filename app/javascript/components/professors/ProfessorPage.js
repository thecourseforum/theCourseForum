import React from "react"
import PropTypes from "prop-types"

// className's defined in app/assets/styleseets/professor.scss
// rails data is passed to react_component as parameters in views/professors/show.html.slim
class ProfessorPage extends React.Component {

  render() {

    // outer map for "subdepartment_chunk" loop
    // inner map for "course" loop

    const courses = this.props.courses.map((course) =>
      <div key={course.course.id} className="row course-panel">
        <div className="col-xs-4 name-block">
          <div className="row course-title">
            <p>{course.course.title}</p>
          </div>
        </div>
      </div>
    );

    return (
      <React.Fragment>
        <div className="professors-container">
          <div className="row professor-header">
            <div className="col-md-4 professor-name">
              <h1>{this.props.professor_name}</h1>
            </div>
            <div className="col-md-4 avg-rating pull-right">
              <h1>{this.props.avg_rating}</h1>
              <p> Average Rating </p>
            </div>
            <div className="col-md-4 avg-difficulty pull-right">
              <h1>{this.props.avg_difficulty}</h1>
              <p> Average Difficulty </p>
            </div>
          </div>

          <hr></hr>

          <div className="row professor-courses">
            {courses}
          </div>
        </div>
      </React.Fragment>
    );
  }
}



export default ProfessorPage
