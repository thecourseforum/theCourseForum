import React from "react"
import PropTypes from "prop-types"

// className's defined in app/assets/styleseets/professor.scss
// rails data is passed to react_component as parameters in views/professors/show.html.slim
// https://reactjs.org/docs/faq-functions.html
// ^ great resource for implementing onClick() with React
class ProfessorPage extends React.Component {

  constructor(props) {
    super(props);
    this.handleCourseClick = this.handleCourseClick.bind(this);
  }

  handleCourseClick(course) {
    let redirectTo = '/courses/' + course.course.id + '?p=' + this.props.professor_id;
    window.location.href = redirectTo;
  }


  render() {

    const professor_subdepartments = this.props.course_groups.map((subdepartment) => {
      const courses = subdepartment[1].map((course) =>
        <div key={course.course.id} className="row course-panel">
          <div className="col-xs-4">
            <button className="course-name-block" type="button" onClick={this.handleCourseClick.bind(this, course)}>
              {course.course.title} ({course.course.course_number})
            </button>
          </div>

          <div className="col-xs-8 course-details-block">
            <div className="col-xs-2">
              <div className="row rating-subheader">
                <span>RATING</span>
              </div>
              <div className="row course-rating-row">
                <h4>{(course.course_stats.rating === null) ? "--" : course.course_stats.rating.toFixed(2)}</h4>
              </div>
            </div>

            <div className="col-xs-2">
              <div className="row rating-subheader">
                <span>DIFFICULTY</span>
              </div>
              <div className="row course-rating-row">
              <h4>{(course.course_stats.difficulty === null) ? "--" : course.course_stats.difficulty.toFixed(2)}</h4>
              </div>
            </div>

            <div className="col-xs-2">
              <div className="row rating-subheader">
                <span>GPA</span>
              </div>
              <div className="row course-rating-row">
              <h4>{(course.course_stats.gpa === null) ? "--" : course.course_stats.gpa.toFixed(2)}</h4>
              </div>
            </div>

            <div className="col-xs-2 pull-right">
              <div className="row rating-subheader-semester">
                <span>LAST TAUGHT</span>
              </div>
              <div className="row course-rating-row-semester">
                <h4>{course.semester.season + " " + course.semester.year}</h4>
              </div>
            </div>
          </div>
        </div>
      );

      return (
        <div className="row">
          <h3 className="subdepartment-name">{subdepartment[0].name}</h3>
          {courses}
          <br></br>
        </div>
      )
    });

    return (
      <React.Fragment>
        <div className="container-fluid professors-container">
          <div className="row professor-header">
            <div className="col-md-4 professor-name">
              <h1><b>{this.props.professor_name}</b></h1>
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

          {professor_subdepartments}

        </div>
      </React.Fragment>
    );
  }
}



export default ProfessorPage
