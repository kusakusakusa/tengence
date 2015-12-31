var GenericTenderRow = React.createClass({
  render: function() {
    var watchlistButton;
    if (this.props.watched) {
      watchlistButton = <UnwatchButton unwatchPath={this.props.unwatchPath} refNo={this.props.refNo} />;
    } else {
      watchlistButton = <WatchButton watchPath={this.props.watchPath} refNo={this.props.refNo} />;
    };
    return (
      <tr>
        <td>{this.props.description}</td>
        <td>{this.props.publishedDate}</td>
        <td>{this.props.closingDate}</td>
        <td>{this.props.closingTime}</td>
        <td>{this.props.buyerCompanyName}</td>
        <td>{watchlistButton}</td>
        <td><MoreButton showPath={this.props.showPath} refNo={this.props.refNo}/></td>
      </tr>
    );
  }
});
