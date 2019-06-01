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
        <div className="col-md-4 professor-name">
          <h1><b>{this.props.professor_name}</b></h1>
          <h5>{(this.props.professor_email === null) ? "" : this.props.professor_email}</h5>
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
    );
  }

  handleCourseClick(course) {
    let redirectTo = '/courses/' + course.course.id + '?p=' + this.props.professor_id;
    window.location.href = redirectTo;
  }

  buildCourseDetailsBlock(label, value) {
    return (
      <div className="col-xs-2">
        <div className="row rating-subheader">
          <span>{label}</span>
        </div>
        <div className="row course-rating-row">
          <h4>{(value === null) ? "--" : value.toFixed(2)}</h4>
        </div>
      </div>
    );
  }

  buildProfessorSubdepartments() {
    const subdepartments = this.props.course_groups.map((subdepartment) => {
      const courses = subdepartment[1].map((course) =>
        <div key={course.course.id} className="row course-panel">
          <div className="col-xs-4">
            <button className=" btn btn-primary course-name-block" type="button" onClick={this.handleCourseClick.bind(this, course)}>
              {course.course.title} ({course.course.course_number})
            </button>
          </div>
          <div className="col-xs-8 course-details-block">
            {this.buildCourseDetailsBlock.call(this, "RATING", course.course_stats.rating)}
            {this.buildCourseDetailsBlock.call(this, "DIFFICULTY", course.course_stats.difficulty)}
            {this.buildCourseDetailsBlock.call(this, "GPA", course.course_stats.gpa)}
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
        </div>
      );
    });

    return (
      <div className="row professor-subdepartments">
        {subdepartments}
      </div>
    );
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
