var PaginationLink = React.createClass({
  handleClick: function(e){
    e.preventDefault();
    $('#select_all').prop('checked', false);
    var link;
    if (this.props.path.indexOf('?') === -1) {
      link = this.props.path + '?page=' + this.props.page;
    } else {
      link = this.props.path + '&page=' + this.props.page;
    }
    var searchField = document.getElementById('query-field');
    if (searchField != null) {
      this.props.getTenders(link, document.getElementById('query-field').value);
    } else {
      this.props.getTenders(link);
    }
  },
  render: function(){
    if (this.props.path != null){
      if (this.props.currentPage != null) {
        return <span>{this.props.children}</span>
      } else {
        return <a href='' onClick={this.handleClick}>{this.props.children}</a>
      }
    } else {
      return <span>{this.props.children}</span>
    }
  }
})