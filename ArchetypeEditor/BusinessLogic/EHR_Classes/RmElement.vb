'
'
'	component:   "openEHR Archetype Project"
'	description: "$DESCRIPTION"
'	keywords:    "Archetype, Clinical, Editor"
'	author:      "Sam Heard"
'	support:     https://openehr.atlassian.net/browse/AEPR
'	copyright:   "Copyright (c) 2004,2005,2006 Ocean Informatics Pty Ltd"
'	license:     "See notice at bottom of class"
'
'

Option Strict On

Public Class RmElement
    Inherits RmStructure

    Private colReferences As New System.Collections.Specialized.StringCollection
    Protected cConstraint As Constraint
    Protected boolHasReferences As Boolean

    Public Overridable ReadOnly Property IsReference() As Boolean
        Get
            Return False
        End Get
    End Property

    Public Overridable Property HasReferences() As Boolean
        Get
            Return boolHasReferences
        End Get
        Set(ByVal Value As Boolean)
            boolHasReferences = Value
        End Set
    End Property

    Public Overridable Function CanChangeDataType(ByVal archetypeSpecialisationDepth As Integer) As Boolean
        Return archetypeSpecialisationDepth = SpecialisationDepth()
    End Function

    Public Overrides ReadOnly Property Type() As StructureType
        Get
            Return StructureType.Element
        End Get
    End Property

    Public Overridable ReadOnly Property DataType() As String
        Get
            Return cConstraint.Kind.ToString
        End Get
    End Property

    Public Overridable Property Constraint() As Constraint
        Get
            Return cConstraint
        End Get
        Set(ByVal Value As Constraint)
            cConstraint = Value
        End Set
    End Property

    Public Overrides Function Copy() As RmStructure
        Dim result As New RmElement(NodeId)

        ' Also copies if it is a reference but no longer leaves it as a reference
        ' Used in specialisation of archetypes
        result.Occurrences = Occurrences.Copy
        result.Constraint = Constraint.Copy
        result.NodeId = NodeId

        If Not mNameConstraint Is Nothing Then
            result.NameConstraint = CType(mNameConstraint.Copy, Constraint_Text)
        End If

        Return result
    End Function

    Private constraintNullFlavours As CodePhrase = New CodePhrase("openehr")

    Public Property ConstrainedNullFlavours() As CodePhrase
        Get
            Return constraintNullFlavours
        End Get
        Set(ByVal value As CodePhrase)
            constraintNullFlavours = value
        End Set
    End Property

    Public Function HasNullFlavourConstraint() As Boolean
        Return constraintNullFlavours.Codes.Count > 0
    End Function

    Sub New(ByVal e As RmElement)
        MyBase.New(e)
        ' for reference
    End Sub

    Sub New(ByVal nodeId As String)
        MyBase.New(nodeId, StructureType.Element)
    End Sub

    Sub New(ByVal xmlElement As XMLParser.C_COMPLEX_OBJECT)
        MyBase.New(xmlElement)
    End Sub

    Sub New(ByVal eifElement As openehr.openehr.am.archetype.constraint_model.C_COMPLEX_OBJECT)
        MyBase.New(eifElement)
    End Sub

End Class

'
'***** BEGIN LICENSE BLOCK *****
'Version: MPL 1.1/GPL 2.0/LGPL 2.1
'
'The contents of this file are subject to the Mozilla Public License Version 
'1.1 (the "License"); you may not use this file except in compliance with 
'the License. You may obtain a copy of the License at 
'http://www.mozilla.org/MPL/
'
'Software distributed under the License is distributed on an "AS IS" basis,
'WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
'for the specific language governing rights and limitations under the
'License.
'
'The Original Code is RmElement.vb.
'
'The Initial Developer of the Original Code is
'Sam Heard, Ocean Informatics (www.oceaninformatics.biz).
'Portions created by the Initial Developer are Copyright (C) 2004
'the Initial Developer. All Rights Reserved.
'
'Contributor(s):
'	Heath Frankel
'
'Alternatively, the contents of this file may be used under the terms of
'either the GNU General Public License Version 2 or later (the "GPL"), or
'the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
'in which case the provisions of the GPL or the LGPL are applicable instead
'of those above. If you wish to allow use of your version of this file only
'under the terms of either the GPL or the LGPL, and not to allow others to
'use your version of this file under the terms of the MPL, indicate your
'decision by deleting the provisions above and replace them with the notice
'and other provisions required by the GPL or the LGPL. If you do not delete
'the provisions above, a recipient may use your version of this file under
'the terms of any one of the MPL, the GPL or the LGPL.
'
'***** END LICENSE BLOCK *****
'
