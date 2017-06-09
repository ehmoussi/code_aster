! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine mmsauv(ds_contact, izone, iptc, nummam, ksipr1,&
                  ksipr2, tau1, tau2, nummae, numnoe,&
                  ksipc1, ksipc2, wpc)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer :: iptc, izone
    integer :: nummam, nummae, numnoe
    real(kind=8) :: ksipr1, ksipr2
    real(kind=8) :: ksipc1, ksipc2
    real(kind=8) :: tau1(3), tau2(3)
    real(kind=8) :: wpc
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES CONTINUES - APPARIEMENT)
!
! SAUVEGARDE APPARIEMENT - CAS MAIT_ESCL
!
! ----------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! IN  IPTC   : NUMERO DE LA LIAISON DE CONTACT
! IN  IZONE  : NUMERO DE LA ZONE
! IN  NUMMAM : NUMERO ABSOLU MAILLE MAITRE QUI RECOIT LA PROJECTION
! IN  NUMMAE : NUMERO ABSOLU MAILLE ESCLAVE
! IN  NUMNOE : NUMERO ABSOLU DU PT INTEG DANS LES SD CONTACT SI
!              INTEG.NOEUDS
! IN  KSIPR1 : PREMIERE COORDONNEE PARAMETRIQUE PT CONTACT PROJETE
!              SUR MAILLE MAITRE
! IN  KSIPR2 : SECONDE COORDONNEE PARAMETRIQUE PT CONTACT PROJETE
!              SUR MAILLE MAITRE
! IN  TAU1   : PREMIERE TANGENTE
! IN  TAU2   : SECONDE TANGENTE
! IN  KSIPC1 : PREMIERE COORDONNEE PARAMETRIQUE PT CONTACT
! IN  KSIPC2 : SECONDE COORDONNEE PARAMETRIQUE PT CONTACT
! IN  WPC    : POIDS INTEGRATION
!
!
!
!
    integer :: ztabf
    character(len=24) :: tabfin
    integer :: jtabf
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD CONTACT
!
    tabfin = ds_contact%sdcont_solv(1:14)//'.TABFIN'
    call jeveuo(tabfin, 'E', jtabf)
    ztabf = cfmmvd('ZTABF')
    ASSERT(izone.gt.0)
!
! --- STOCKAGE DES VALEURS POUR LE CHAM_ELEM (VOIR MMCHML)
!
    zr(jtabf+ztabf*(iptc-1)+2) = nummam
    zr(jtabf+ztabf*(iptc-1)+5) = ksipr1
    zr(jtabf+ztabf*(iptc-1)+6) = ksipr2
    zr(jtabf+ztabf*(iptc-1)+7) = tau1(1)
    zr(jtabf+ztabf*(iptc-1)+8) = tau1(2)
    zr(jtabf+ztabf*(iptc-1)+9) = tau1(3)
    zr(jtabf+ztabf*(iptc-1)+10) = tau2(1)
    zr(jtabf+ztabf*(iptc-1)+11) = tau2(2)
    zr(jtabf+ztabf*(iptc-1)+12) = tau2(3)
    zr(jtabf+ztabf*(iptc-1)+13) = izone
!
! --- STOCKAGE DES VALEURS POUR LE CHAM_ELEM (VOIR MMCHML)
!
    zr(jtabf+ztabf*(iptc-1)+1) = nummae
    zr(jtabf+ztabf*(iptc-1)+3) = ksipc1
    zr(jtabf+ztabf*(iptc-1)+4) = ksipc2
    zr(jtabf+ztabf*(iptc-1)+14) = wpc
    zr(jtabf+ztabf*(iptc-1)+24) = numnoe
!
    call jedema()
end subroutine
