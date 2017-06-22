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

subroutine te0261(option, nomte)
! person_in_charge: samuel.geniaut at edf.fr
!.......................................................................
!
!     BUT: CALCUL DES CONTRAINTES AUX POINTS DE GAUSS
!          EN X-FEM
!
!          OPTION : 'SIEF_ELGA'
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!              ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/iselli.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/ltequa.h"
#include "asterfort/teattr.h"
#include "asterfort/xsidep.h"
#include "asterfort/xteini.h"
    character(len=16) :: nomte, option
    character(len=8) :: enr, typmod(2), elrefp
    character(len=16) :: compor(4)
    integer :: ndim, nfh, nno, nnos, npg1, ipoids, ivf, idfde, jgano
    integer :: jpintt, jcnset, jheavt, jlonch, jbaslo, jlsn, jlst, jstno, jpmilt, jheavn
    integer :: igeom, idepl, imate, icont
    integer :: ddlc, nddl, nnom, nfe, ibid, ddls, ddlm, nfiss
!
!
! ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
! ---- GEOMETRIE ET INTEGRATION
!      ------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    option=option
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
    call elref1(elrefp)
!
! ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
!      -----------------------------------------
!     MATNS MAL DIMENSIONNEE
    ASSERT(nno.le.27)
!     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
    call xteini(nomte, nfh, nfe, ibid, ddlc,&
                nnom, ddls, nddl, ddlm, nfiss,&
                ibid)
!
! - TYPE DE MODELISATION
    if (ndim .eq. 3) then
        typmod(1) = '3D'
        typmod(2) = '  '
    else
        if (lteatt('AXIS','OUI')) then
            typmod(1) = 'AXIS'
        else if (lteatt('C_PLAN','OUI')) then
            typmod(1) = 'C_PLAN'
        else if (lteatt('D_PLAN','OUI')) then
            typmod(1) = 'D_PLAN'
        else
            ASSERT(.false.)
        endif
        typmod(2) = ' '
    endif
!
!
! - PARAMETRES EN ENTREE
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PDEPLAR', 'L', idepl)
    compor(1)=' '
    compor(2)=' '
    compor(3)=' '
    compor(4)=' '
!
!
!     PARAMETRES PROPRES A X-FEM
    call jevech('PPINTTO', 'L', jpintt)
    call jevech('PCNSETO', 'L', jcnset)
    call jevech('PHEAVTO', 'L', jheavt)
    call jevech('PLONCHA', 'L', jlonch)
    call jevech('PBASLOR', 'L', jbaslo)
    call jevech('PLSN', 'L', jlsn)
    call jevech('PLST', 'L', jlst)
    call jevech('PSTANO', 'L', jstno)
    call teattr('S', 'XFEM', enr, ibid)
    if (enr(1:2).eq.'XH' .or. enr(1:2).eq.'XT') call jevech('PHEA_NO', 'L', jheavn)
!     PROPRES AUX ELEMENTS 1D ET 2D (QUADRATIQUES)
    if ((ibid.eq.0) .and. ltequa(elrefp,enr))&
    call jevech('PPMILTO', 'L', jpmilt)
!
    call jevech('PCONTRR', 'E', icont)
!
    call xsidep(nno, nfh, nfe, ddlc, ddlm,&
                igeom, typmod, zi(imate), compor, jpintt,&
                zi(jcnset), zi(jheavt), zi(jlonch), zr(jbaslo), idepl,&
                zr(jlsn), zr(jlst), zr(icont), jpmilt, nfiss,&
                jheavn, jstno)
end subroutine
