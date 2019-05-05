import React from "react"
import PropTypes from "prop-types"

/**
* A React component that fetches GPA for a course
* Contains links to each department at UVA
*
* TODO: In the future, instead of making 100 requests, each of 1 GPA,
*       write the course list page in react so we can make 1 request with
*       100 GPAs.
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
    fetch(`/grades/api/v1/${this.props.subject}/${this.props.number}/gpa`)
      .then((response) => {
        if (response.ok) {
          return response.json();
        }
        throw new Error('Network response was not ok.');
      })
      .then((json) => {
        const gpa = json == null ? "--" : json.toFixed(2);
        this.setState({
          gpa: gpa
        })
      })
      .catch(error => {
        console.log(error);
      });
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
};
export default GPACard
