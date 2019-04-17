import React from "react"
import PropTypes from "prop-types"
import Image from 'images/about/uvaparentsfund.png'

class ParentsFund extends React.Component {

  render () {
    return (
      <React.Fragment>
        <img className="text-left" src={Image} alt="UVA Parents Fund"/>
        <h4 className="thanks">{this.props.title}</h4>
        <p className="about">With the release of our scheduler feature, the UVA Parents Fund helped us cover increased server costs from the traffic. Their help has allowed the site to stay up and running continuously as we keep developing new features.</p>
      </React.Fragment>
    );
  }
}

ParentsFund.propTypes = {
  title: PropTypes.string
};
export default ParentsFund
