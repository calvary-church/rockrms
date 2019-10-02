<%@ Page Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" Inherits="Rock.Web.UI.RockPage" %>


<asp:Content ID="ctFeature" ContentPlaceHolderID="feature" runat="server">

    <section class="main-feature">
      <Rock:Zone Name="Feature" runat="server" />
    </section>

</asp:Content>


<asp:Content ID="ctMain" ContentPlaceHolderID="main" runat="server">

    <main>

        <!-- Start Content Area -->

        <!-- Ajax Error -->
        <div class="alert alert-danger ajax-error no-index" style="display:none">
            <p><strong>Error</strong></p>
            <span class="ajax-error-message"></span>
        </div>
        <div class="container">
        <div class="row">
            <div class="col-md-9">
                <Rock:Zone Name="Main" runat="server" />
                <Rock:Zone Name="Section A" runat="server" />
                <Rock:Zone Name="Section B" runat="server" />
                <Rock:Zone Name="Section C" runat="server" />
                <Rock:Zone Name="Section D" runat="server" />
            </div>
            <div class="col-md-3 right-sidebar">
                <Rock:Zone Name="Right Column" runat="server" />
            </div>        <!-- End Content Area -->
        </div>
    </main>

</asp:Content>
