import React from "react"
import PropTypes from "prop-types"
import Ad1Base from 'images/ads/Img1.1.png'
import Ad1Hover from 'images/ads/Img1.2.png'
import Ad2Base from 'images/ads/Img2.1.png'
import Ad2Hover from 'images/ads/Img2.2.png'

class Ad extends React.Component {

  constructor(props) {
    super(props);
    switch(props.ad) {
      case 2:
        this.state = {
          imageBase: Ad2Base,
          imageHover: Ad2Hover,
          link: "https://hackcville.com/launch-tcf",
        };
        break;
      default:
        this.state = {
          imageBase: Ad1Base,
          imageHover: Ad1Hover,
          link: "https://hackcville.com/apply-tcf",
        };
    }
  }

  render () {
    return (
      <div>
        <a href={this.state.link} target="_blank">
          <img 
            src={this.state.imageBase}
            alt="HackCville ad"
            onMouseOver = {
              e => (e.currentTarget.src = this.state.imageHover)
            }
            onMouseOut = {
              e => (e.currentTarget.src = this.state.imageBase)
            }
          />
        </a>
      </div>
    );
  }
}

Ad.propTypes = {
  ad: PropTypes.number
};
export default Ad