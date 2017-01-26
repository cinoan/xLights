#ifndef REMAPDIALOG_H
#define REMAPDIALOG_H

//(*Headers(RemapDialog)
#include <wx/sizer.h>
#include <wx/stattext.h>
#include <wx/spinctrl.h>
#include <wx/button.h>
#include <wx/dialog.h>
//*)

class RemapDialog: public wxDialog
{
    size_t& _from;
    size_t& _to;
    size_t& _channels;

	public:

		RemapDialog(wxWindow* parent, size_t& startChannel, size_t& to, size_t& channels,wxWindowID id=wxID_ANY,const wxPoint& pos=wxDefaultPosition,const wxSize& size=wxDefaultSize);
		virtual ~RemapDialog();

		//(*Declarations(RemapDialog)
		wxButton* Button_Ok;
		wxSpinCtrl* SpinCtrl_ToChannel;
		wxSpinCtrl* SpinCtrl_Channels;
		wxStaticText* StaticText2;
		wxStaticText* StaticText1;
		wxStaticText* StaticText3;
		wxButton* Button_Cancel;
		wxSpinCtrl* SpinCtrl_FromChannel;
		//*)

	protected:

		//(*Identifiers(RemapDialog)
		static const long ID_STATICTEXT1;
		static const long ID_SPINCTRL1;
		static const long ID_STATICTEXT2;
		static const long ID_SPINCTRL2;
		static const long ID_STATICTEXT3;
		static const long ID_SPINCTRL3;
		static const long ID_BUTTON1;
		static const long ID_BUTTON2;
		//*)

	private:

		//(*Handlers(RemapDialog)
		void OnButton_OkClick(wxCommandEvent& event);
		void OnButton_CancelClick(wxCommandEvent& event);
		//*)

		DECLARE_EVENT_TABLE()
};

#endif