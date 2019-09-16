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
    this.buildProfessorHeader = this.buildProfessorHeader.bind(this);
    this.buildProfessorSubdepartments = this.buildProfessorSubdepartments.bind(this);
    this.buildCourseDetailsBlock = this.buildCourseDetailsBlock.bind(this);
  }

  buildProfessorHeader() {
    return (
      <div className="row professor-header">
        <div className="col-xs-4 professor-header-name">
          <h1><b>{this.props.professor_name}</b></h1>
          <h5>{(this.props.professor_email === null) ? "" : this.props.professor_email}</h5>
        </div>
        <div className="col-xs-4 professor-header-rating pull-right">
          <h1>{this.props.avg_rating}</h1>
          <p> Average Rating </p>
        </div>
        <div className="col-xs-4 professor-header-rating pull-right">
          <h1>{this.props.avg_difficulty}</h1>
          <p> Average Difficulty </p>
        </div>
      </div>
    );
  }

  handleCourseClick(course) {
    let redirectTo = '/courses/' + course.course.id + '?p=' + this.props.professor_id;
    window.location.href = redirectTo;
  }

  buildCourseDetailsBlock(label, value) {
    return (
      <div className="col-xs-2">
        <div className="row course-details-label">
          <span>{label}</span>
        </div>
        <div className="row course-details-value">
          <h4>{(value === null) ? "--" : value.toFixed(2)}</h4>
        </div>
      </div>
    );
  }

  buildProfessorSubdepartments() {
    const subdepartments = this.props.course_groups.map((subdepartment) => {
      const courses = subdepartment[1].map((course) =>
        <div key={course.course.id} className="row course-box">
          <div className="row button-row">
            <button className=" btn btn-primary course-button" type="button" onClick={this.handleCourseClick.bind(this, course)}>
              {course.course.title} ({course.course.course_number})
            </button>
          </div>
          <div className="row ratings-row">
            {this.buildCourseDetailsBlock.call(this, "RATING", course.course_stats.rating)}
            {this.buildCourseDetailsBlock.call(this, "DIFFICULTY", course.course_stats.difficulty)}
            {this.buildCourseDetailsBlock.call(this, "GPA", course.course_stats.gpa)}
            <div className="col-xs-2">
              <div className="row course-details-label">
                <span>LAST TAUGHT</span>
              </div>
              <div className="row course-details-value">
                <h4>{course.semester.season + " " + course.semester.year}</h4>
              </div>
            </div>
          </div>
        </div>
      );

      return (
        <div className="row subdepartment-box">
          <h3>{subdepartment[0].name}</h3>
          {courses}
        </div>
      );
    });

    return (subdepartments);
  }


  render() {
    const professorHeader = this.buildProfessorHeader.call();
    const professorSubdepartments = this.buildProfessorSubdepartments.call();

    return (
      <React.Fragment>
        <div className="container-fluid professors-container">
          {professorHeader}
          <hr></hr>
          {professorSubdepartments}
        </div>
      </React.Fragment>
    );
  }
}



export default ProfessorPage
