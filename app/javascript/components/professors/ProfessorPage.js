import React from "react"
import PropTypes from "prop-types"

// className's defined in app/assets/styleseets/professor.scss
// rails data is passed to react_component as parameters in views/professors/show.html.slim
class ProfessorPage extends React.Component {

  render() {

    const subdepartment_chunks = this.props.course_groups.map((chunk) => {
      const courses = chunk[1].map((course) =>
        <div key={course.course.id} className="row course-panel">
          <div className="col-xs-4 name-block data-no-turbolink">
            <div className="row course-title">
              <a href={'/courses/' + course.course.id + '?p=' + this.props.professor_id}>{course.course.title}</a>
            </div>
          </div>
        </div>
      );

      return (
        <div className="row">
          <h3 className="subdepartment-name">{chunk[0].name}</h3>
          {courses}
        </div>
      )
    });

    return (
      <React.Fragment>
        <div className="container professors-container">
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

          {subdepartment_chunks}

        </div>
      </React.Fragment>
    );
  }
}



export default ProfessorPage
