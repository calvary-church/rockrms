<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EventsList.ascx.cs" Inherits="RockWeb.Blocks.Event.CalendarLava" %>

<asp:UpdatePanel ID="upnlEventsList" runat="server">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="cblCampus" />
        <asp:AsyncPostBackTrigger ControlID="ddlCategory" />
    </Triggers>
    <ContentTemplate>

        <Rock:NotificationBox ID="nbMessage" runat="server" Visible="false" />

        <asp:Panel id="pnlFilters" runat="server" CssClass="row">

            <asp:Panel ID="pnlCategories" CssClass="col-sm-12 hidden-print" runat="server">

            <div class="filters form-inline">
            
            		<div class="filters-campus">

                <%-- Note: RockControlWrapper/Div/CheckboxList is being used instead of just a RockCheckBoxList, because autopostback does not currently work for RockControlCheckbox--%>
                <Rock:RockControlWrapper ID="rcwCampus" runat="server" Label="Choose Campus:">
                    <div class="controls">
                        <asp:CheckBoxList ID="cblCampus" RepeatDirection="Horizontal" runat="server" DataTextField="Name" DataValueField="Id"
                            OnSelectedIndexChanged="cblCampus_SelectedIndexChanged" AutoPostBack="true" />
                    </div>
                </Rock:RockControlWrapper>
                
              </div>
              <div class="filters-category">


                <% if ( CategoryPanelOpen || CategoryPanelClosed )
                   { %>
                <Rock:RockControlWrapper ID="rcwCategory" runat="server" Label="Filter By Category">
                    <div class="controls">
                        <Rock:RockDropDownList ID="ddlCategory" runat="server" DataTextField="Value" DataValueField="Id" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" AutoPostBack="true" />
                    </div>
                </Rock:RockControlWrapper>
                <% } %>
                
                <Rock:BootstrapButton ID="btnReset" runat="server" CssClass="button button--primary button--solid" Text="Reset Filters" OnClick="btnReset_Click" />
  
              </div>
                              
            </div>

            </asp:Panel>

        </asp:Panel>

        <asp:Panel id="pnlDetails" runat="server" CssClass="custom-events-list row">

            <asp:Panel ID="pnlSidebar" CssClass="sidebar margin-b-lg hidden-print" runat="server">

                <asp:Panel ID="pnlCalendar" CssClass="calendar margin-b-md" runat="server">
                    <asp:Calendar ID="calEventCalendar" runat="server" DayNameFormat="FirstLetter" SelectionMode="Day" BorderStyle="None"
                        TitleStyle-BackColor="#ffffff" NextPrevStyle-ForeColor="#333333" FirstDayOfWeek="Sunday" Width="100%" CssClass="calendar-month" OnSelectionChanged="calEventCalendar_SelectionChanged" OnDayRender="calEventCalendar_DayRender" OnVisibleMonthChanged="calEventCalendar_VisibleMonthChanged">
                        <DayStyle CssClass="calendar-day" />
                        <TodayDayStyle CssClass="calendar-today" />
                        <SelectedDayStyle CssClass="calendar-selected" BackColor="Transparent" />
                        <OtherMonthDayStyle CssClass="calendar-last-month" />
                        <DayHeaderStyle CssClass="calendar-day-header" />
                        <NextPrevStyle CssClass="calendar-next-prev" />
                        <TitleStyle CssClass="calendar-title" />
                    </asp:Calendar>
                </asp:Panel>

								<div class="text-center">
	
	                <Rock:DateRangePicker ID="drpDateRange" runat="server" Label="Select Range" /><asp:LinkButton ID="lbDateRangeRefresh" runat="server" CssClass="btn btn-default btn-sm" Text="Refresh" OnClick="lbDateRangeRefresh_Click" />

	                <div class="btn-group hidden-print" role="group">
	                    <Rock:BootstrapButton ID="btnDay" runat="server" CssClass="btn btn-default" Text="Day" OnClick="btnViewMode_Click" />
	                    <Rock:BootstrapButton ID="btnWeek" runat="server" CssClass="btn btn-default" Text="Week" OnClick="btnViewMode_Click" />
	                    <Rock:BootstrapButton ID="btnMonth" runat="server" CssClass="btn btn-default" Text="Month" OnClick="btnViewMode_Click" />
	                    <Rock:BootstrapButton ID="btnYear" runat="server" CssClass="btn btn-default" Text="Year" OnClick="btnViewMode_Click" />
	                    <Rock:BootstrapButton ID="btnAll" runat="server" CssClass="btn btn-default" Text="All" OnClick="btnViewMode_Click" />
	                </div>
                </div>

            </asp:Panel>

            <asp:Panel ID="pnlList" CssClass="events-list" runat="server">

                <asp:Literal ID="lOutput" runat="server"></asp:Literal>
                <asp:Literal ID="lDebug" Visible="false" runat="server"></asp:Literal>

            </asp:Panel>

        </asp:Panel>

    </ContentTemplate>

</asp:UpdatePanel>
