import React from "react"
import PropTypes from "prop-types"

/**
* A React version of our /browse page.
* Contains links to each department at UVA
*/
class Browse extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      schools: null
    }
  }

  /**
  * On component mount, fetch json with list of courses.
  * Update state.
  */
  componentDidMount = () => {
    fetch('/browse.json')
      .then((response) => {
        return response.json();
      })
      .then((json) => {
        this.setState({
          schools: json
        })
      });
  }

  /*
  * Decides which icon to use based on school name
  */
  departmentIcon = (props) => {
    switch(props.departmentName) {
      case 'Arts & Sciences':
        return <span className="glyphicon glyphicon-th-list"/>;
      case 'Engineering & Applied Sciences':
        return <span className="glyphicon glyphicon-cog"/>;
      default: // Other Schools at the University of Virginia
        return <span className="glyphicon glyphicon-star"/>;
    }
  }

  /*
  * Maps through each department in props.arr
  * and generates a link for each
  */
  departmentLinks = (props) => {
    const links = props.arr.map((dep) =>
      <div key={dep.id} className="dept">
        <a href={"/departments/" + dep.id}>
          {dep.name}
        </a>
      </div>
    );
    return (
      <div className="col-sm-6">
        {links}
      </div>
    )
  }

  /*
  * Generates a panel for school in props.school,
  * populating links.
  * Note that each school has 2 link arrays, presumably
  * to split them up into columns.
  */
  schoolPanel = (props) => {
    return (
      <div className="panel panel-default">
        <div className="school-panel-title">
          <div className="dept-block">
            <this.departmentIcon
              departmentName={props.schoolName}
            />
          </div>
          <h3 className="school-title">{props.schoolName}</h3>
        </div>
        <div className="panel-body">
          <div className="row department-list">
            <this.departmentLinks
              arr={this.state.schools[props.schoolName][0]}
            />
            <this.departmentLinks
              arr={this.state.schools[props.schoolName][1]}
            />
          </div>
        </div>
      </div>
    )
  }

  /*
  * Render loading if this.state.schools has not yet been fetched
  * Otherwise, render a panel for each school.
  */
  render () {
    if (this.state.schools == null) {
      return <h1>Loading...</h1>
    }
    const schoolPanels = Object.keys(this.state
    .schools).map(schoolName =>
      <this.schoolPanel
        key={schoolName}
        schoolName={schoolName}
      />
    );
    return (
      <React.Fragment>
        <div className="container-fluid" id="browsing-content">
          {schoolPanels}
        </div>
      </React.Fragment>
    );
  }
}

export default Browse
