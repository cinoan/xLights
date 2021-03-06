#ifndef SEQEXPORTDIALOG_H
#define SEQEXPORTDIALOG_H

//(*Headers(SeqExportDialog)
#include <wx/sizer.h>
#include <wx/stattext.h>
#include <wx/textctrl.h>
#include <wx/choice.h>
#include <wx/button.h>
#include <wx/dialog.h>
//*)

class SeqExportDialog: public wxDialog
{
    std::string _model;
    void ValidateWindow();

public:

    SeqExportDialog(wxWindow* parent, const std::string& model, wxWindowID id=wxID_ANY,const wxPoint& pos=wxDefaultPosition,const wxSize& size=wxDefaultSize);
    virtual ~SeqExportDialog();
    void ModelExportTypes(bool isgroup);

    //(*Declarations(SeqExportDialog)
    wxTextCtrl* TextCtrlFilename;
    wxStaticText* StaticText1;
    wxStaticText* StaticText3;
    wxButton* ButtonFilePick;
    wxChoice* ChoiceFormat;
    wxButton* ButtonCancel;
    wxButton* ButtonOk;
    //*)

protected:

    //(*Identifiers(SeqExportDialog)
    static const long ID_STATICTEXT1;
    static const long ID_CHOICE1;
    static const long ID_STATICTEXT3;
    static const long ID_TEXTCTRL2;
    static const long ID_BUTTON1;
    static const long ID_BUTTON2;
    static const long ID_BUTTON3;
    //*)

private:

    //(*Handlers(SeqExportDialog)
    void OnChoiceFormatSelect(wxCommandEvent& event);
    void OnButtonFilePickClick(wxCommandEvent& event);
    void OnButtonOkClick(wxCommandEvent& event);
    void OnButtonCancelClick(wxCommandEvent& event);
    void OnTextCtrlFilenameText(wxCommandEvent& event);
    //*)

    DECLARE_EVENT_TABLE()
};

#endif
