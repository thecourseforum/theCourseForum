import React from "react"
import PropTypes from "prop-types"

class Browse extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      departments: null
    }
  }

  componentDidMount = () => {
    fetch('/browse.json')
      .then((response) => {
        return response.json();
      })
      .then((json) => {
        this.setState({
          departments: json
        })
      });
  }

  departmentIcon = (props) => {
    switch(props.departmentName) {
      case 'Arts & Sciences':
        return <span className="glyphicon glyphicon-th-list"/>;
      case 'Engineering & Applied Sciences':
        return <span className="glyphicon glyphicon-cog"/>;
      default:
        return <span className="glyphicon glyphicon-star"/>;
    }
  }

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

  departmentPanel = (props) => {
    return (
      <div className="panel panel-default">
        <div className="school-panel-title">
          <div className="dept-block">
            <this.departmentIcon
              departmentName={props.departmentName}
            />
          </div>
          <h3 className="school-title">{props.departmentName}</h3>
        </div>
        <div className="panel-body">
          <div className="row department-list">
            <this.departmentLinks
              arr={this.state.departments[props.departmentName][0]}
            />
            <this.departmentLinks
              arr={this.state.departments[props.departmentName][1]}
            />
          </div>
        </div>
      </div>
    )
  }

  render () {
    if (this.state.departments == null) {
      return <h1>Loading...</h1>
    }
    const departmentPanels = Object.keys(this.state
    .departments).map(departmentName =>
      <this.departmentPanel
        key={departmentName}
        departmentName={departmentName}
      />
    );
    return (
      <React.Fragment>
        <div className="container-fluid" id="browsing-content">
          {departmentPanels}
        </div>
      </React.Fragment>
    );
  }
}

export default Browse
