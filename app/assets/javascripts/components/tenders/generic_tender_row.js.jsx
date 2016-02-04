var GenericTenderRow = React.createClass({
  render: function() {
    var watchlistButton;
    if (this.props.watched) {
      watchlistButton = <UnwatchButton {...this.props} />;
    } else {
      watchlistButton = <WatchButton {...this.props} />;
    };
    console.log(this.props.trial_tenders_count != null);
    if (this.props.trial_tenders_count != null){
      return (
        <tr>
          <td>{this.props.description}</td>
          <td>{this.props.publishedDate}</td>
          <td>{this.props.closingDate}</td>
          <td>{this.props.closingTime}</td>
          <td>{watchlistButton}</td>
          <td><MoreButton refNo={this.props.refNo}/></td>
        </tr>
      );
    } else {
      return (
        <tr>
          <td>{this.props.description}</td>
          <td>{this.props.publishedDate}</td>
          <td>{this.props.closingDate}</td>
          <td>{this.props.closingTime}</td>
          <td>{this.props.buyerCompanyName}</td>
          <td>{watchlistButton}</td>
          <td><MoreButton refNo={this.props.refNo}/></td>
        </tr>
      );
    }
  }
});
