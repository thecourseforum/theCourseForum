import React from "react"
import PropTypes from "prop-types"

/**
* A React component that fetches GPA for a course
* Contains links to each department at UVA
*/
class GPACard extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      gpa: null
    }
  }

  /**
  * On component mount, fetch json with GPA.
  * Update state.
  */
  componentDidMount = () => {
    // would fetch from microservice here
    console.log(this.props);
    this.setState({gpa: this.props.temp_gpa})
  }

  render () {
    return (
      <h4 className="course-rating">
        { this.state.gpa }
      </h4>
    );
    return null;
  }
}

GPACard.propTypes = {
  subject: PropTypes.string,
  number: PropTypes.number,
  temp_gpa: PropTypes.number
};
export default GPACard
