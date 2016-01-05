var WatchedTendersTableBody = React.createClass({
  render: function() {
    var rows = [];
    var { tenders, ...other } = this.props;
    for (var i=0; i < tenders.length; i++) {
      var closingDate = strftime('%d %b %Y', new Date(tenders[i].closing_datetime));
      var publishedDate = strftime('%d %b %Y', new Date(tenders[i].published_date));
      var closingTime = strftime('%H:%M %p', new Date(tenders[i].closing_datetime))
      rows.push(<WatchedTenderRow key={tenders[i].ref_no} refNo={tenders[i].ref_no} status={tenders[i].status}  description={tenders[i].description} publishedDate={publishedDate} closingDate={closingDate} closingTime={closingTime} buyerCompanyName={tenders[i].buyer_company_name} watchPath={tenders[i].watch_path} unwatchPath={tenders[i].unwatch_path} watched={tenders[i].watched} showPath={tenders[i].show_path} {...other} />);
    }
    return (
      <tbody>
        {rows}
      </tbody>
    );
  }
});