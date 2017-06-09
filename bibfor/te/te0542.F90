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

subroutine te0542(option, nomte)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/ltequa.h"
#include "asterfort/jevech.h"
#include "asterfort/nbsigm.h"
#include "asterfort/teattr.h"
#include "asterfort/terefe.h"
#include "asterfort/xbsig.h"
#include "asterfort/xbsir.h"
#include "asterfort/xbsir2.h"
#include "asterfort/xteddl.h"
#include "asterfort/xteini.h"
#include "asterfort/lteatt.h"
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
! FONCTION REALISEE:  CALCUL DES OPTION FORC_NODA ET REFE_FORC_NODA
!                     POUR LES ÉLÉMENTS MECA X-FEM
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfde, jgano, igeom, ivectu
    integer :: jpintt, jcnset, jheavt, jlonch, jbaslo, icontm, jlsn, jlst
    integer :: jpmilt, ddlm, nfiss, jfisno, ideplm, icompo, jheavn
    integer :: nfh, ddlc, nfe, ibid, ddls, nbsig, nddl, jstno, imate
    integer :: contac, nnom, singu
    aster_logical :: lbid
    real(kind=8) :: sigref(1), depref
    character(len=8) :: enr, elref
! DEB ------------------------------------------------------------------
!
! ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
! ---- GEOMETRIE ET INTEGRATION
!      ------------------------
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    call elref1(elref)
!     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
    call xteini(nomte, nfh, nfe, singu, ddlc,&
                nnom, ddls, nddl, ddlm, nfiss,&
                contac)
!
! ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
!      -----------------------------------------
    nbsig = nbsigm()
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PDEPLMR', 'L', ideplm)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PVECTUR', 'E', ivectu)
!
!     PARAMÈTRES PROPRES À X-FEM
    call jevech('PPINTTO', 'L', jpintt)
    call jevech('PCNSETO', 'L', jcnset)
    call jevech('PHEAVTO', 'L', jheavt)
    call jevech('PLONCHA', 'L', jlonch)
    call jevech('PBASLOR', 'L', jbaslo)
    call jevech('PLSN', 'L', jlsn)
    call jevech('PLST', 'L', jlst)
!     PROPRE AUX ELEMENTS 1D ET 2D (QUADRATIQUES)
    call teattr('S', 'XFEM', enr, ibid)
    if (enr(1:2).eq.'XH') call jevech('PHEA_NO', 'L', jheavn)
    if ((ibid.eq.0) .and. ltequa(elref,enr))&
    call jevech('PPMILTO', 'L', jpmilt)
    if (nfiss .gt. 1) call jevech('PFISNO', 'L', jfisno)
!
    if (option .eq. 'FORC_NODA') then
!      --------------------
! VECTEUR SECOND MEMBRE DONNE EN ENTREE
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PSTANO', 'L', jstno)
        if (nfe.gt.0) then
           call jevech('PMATERC', 'L', imate)
        endif
!       CALCUL DU VECTEUR DES FORCES INTERNES (BT*SIGMA)
        call xbsig(ndim, nno, nfh, nfe, ddlc,&
                   ddlm, igeom, zk16( icompo), jpintt, zi(jcnset),&
                   zi(jheavt), zi(jlonch), zr(jbaslo), zr(icontm), nbsig,&
                   ideplm, zr(jlsn), zr(jlst), ivectu, jpmilt,&
                   nfiss, jheavn, jstno, imate)
!
        call xteddl(ndim, nfh, nfe, ddls, nddl,&
                    nno, nnos, zi(jstno), .false._1, lbid,&
                    option, nomte, ddlm, nfiss, jfisno,&
                    vect=zr(ivectu))
!
    else if (option.eq.'REFE_FORC_NODA') then
!
! --- ON RECUPERE CONTRAINTE ET SAUT DE DEPLACEMENT DE REFERENCE
!
        call terefe('SIGM_REFE', 'MECA_INTERFACE', sigref(1))
        call terefe('DEPL_REFE', 'MECA_INTERFACE', depref)
        if (nfe.gt.0) then
           call jevech('PSTANO', 'L', jstno)
        endif
!
! --- ON COMMENCE PAR CALCULER LES CONTRIBUTIONS VOLUMIQUES
!
        call xbsir(ndim, nno, nfh, nfe, ddlc,&
                   ddlm, igeom, zk16(icompo), jpintt, zi(jcnset),&
                   zi(jheavt), zi(jlonch), zr(jbaslo), sigref, nbsig,&
                   ideplm, zr(jlsn), zr(jlst), ivectu, jpmilt,&
                   nfiss, jheavn, jstno)
!
! --- SI ELEMENT DE CONTACT, ON Y AJOUTE LES CONTRIBUTIONS SURFACIQUES
! --- NOTAMMENT CELLE POUR LES EQUATIONS DUALES
!
        if (enr .eq. 'XHC' .or. enr .eq. 'XHTC') then
            call xbsir2(elref, contac, ddlc, ddlm, ddls,&
                        igeom, jheavn, jlst, ivectu, singu,&
                        nddl, ndim, nfh, nfiss,&
                        nno, nnom, nnos, depref, sigref(1),&
                        jbaslo, jstno, jlsn)
        endif
    else
        ASSERT(.false.)
    endif
! FIN ------------------------------------------------------------------
!
end subroutine
