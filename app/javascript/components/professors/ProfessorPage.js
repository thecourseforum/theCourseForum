import React from "react"
import PropTypes from "prop-types"

// className's defined in app/assets/styleseets/professor.scss
// rails data is passed to react_component as parameters in views/professors/show.html.slim
class ProfessorPage extends React.Component {

  /* WORK IN PROGRESS
  get_course_stats = (props) => {
    const course_stats = props.course.course.stats
    for (int i = 0; i < course_stats.length; i++) {
      let stat = course_stats[i]
      if (stat.professor.full_name == this.props.professor_name) {
        return stat[0]
      }
    }
    return NULL
  }
  */

  constructor(props) {
    super(props);
    this.handleCourseClick = this.handleCourseClick.bind(this);
  }

  handleCourseClick(course) {
    let newLink = '/courses/' + course.course.id + '?p=' + this.props.professor_id
    window.location.href = newLink;
  }


  render() {

    const subdepartment_chunks = this.props.course_groups.map((chunk) => {
      const courses = chunk[1].map((course) =>
        <div key={course.course.id} className="row course-panel">
          <div className="col-xs-4">
            <button className="course-name-block" type="button" onClick={this.handleCourseClick.bind(this, course)}>
              {course.course.title}
            </button>
          </div>

          <div className="col-xs-8 details-block">
            <div className="row info-header">
              <div className="row prof-info-header">

                <div className="col-xs-4 rating-block">
                  <div className="row course-icon">
                    <div className="container rating-container">
                      <div className="row rating-subheader">
                        <span>RATING</span>
                      </div>
                      <div className="row course-rating-row">
                        <h4>--</h4>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="col-xs-4 rating-block">
                  <div className="row course-icon">
                    <div className="container rating-container">
                      <div className="row rating-subheader">
                        <span>DIFFICULTY</span>
                      </div>
                      <div className="row course-rating-row">
                        <h4>--</h4>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="col-xs-4 rating-block">
                  <div className="row course-icon">
                    <div className="container rating-container">
                      <div className="row rating-subheader">
                        <span>GPA</span>
                      </div>
                      <div className="row course-rating-row">
                        <h4>--</h4>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="col-xs-4 rating-block float-right">
                  <div className="row course-icon">
                    <div className="container rating-container">
                      <div className="row rating-subheader">
                        <span>LAST TAUGHT</span>
                      </div>
                      <div className="row course-rating-row">
                        <h4>--</h4>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
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
