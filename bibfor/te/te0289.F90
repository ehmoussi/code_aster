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

subroutine te0289(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/iselli.h"
#include "asterfort/jevech.h"
#include "asterfort/nbsigm.h"
#include "asterfort/xselno.h"
#include "asterfort/xsseno.h"
#include "asterfort/xteini.h"
    character(len=16) :: option, nomte
!
!    - FONCTIONS REALISEES :  ROUTINE X-FEM
!
!          PASSAGE DES CONTRAINTES
!          DES POINTS DE GAUSS DES SOUS-ELEMENTS :
!            * AUX NOEUDS DES ELEMENTS PARENTS
!              (OPTION 'SIEF_ELNO' ET 'SIGM_ELNO') ;
!            * AUX SOMMETS (NOEUDS) DES SOUS-ELEMENTS
!              (OPTION 'SISE_ELNO') ;
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
!
!
!
    integer :: mxval
    parameter (mxval=32*10*6)
!     EN 2D :
!     MXVAL =  6 (NBSE MAX) * 3 (NBNOSE MAX) * 4 (NBCMP MAX)-> en lineaire
!     MXVAL =  6 (NBSE MAX) * 6 (NBNOSE MAX) * 4 (NBCMP MAX)-> en quadratique
!     EN 3D :
!     MXVAL = 32 (NBSE MAX) * 4 (NBNOSE MAX) * 6 (NBCMP MAX)-> en lineaire
!     MXVAL = 32 (NBSE MAX) * 10(NBNOSE MAX) * 6 (NBCMP MAX)-> en quadratique
    integer :: ibid, ndim, nnop, nno, npg, ivf, jgano,irese
    integer :: nfh, nfe, singu, ddlc, nbsig
    integer :: jcnset, jlonch, jsigpg
    integer :: jout1, jout2
    integer :: nse
!
!
    real(kind=8) :: siseno(mxval)
!
    character(len=8) :: elrefp, elrese(6), fami(6)
!
    data    elrese /'SE2','TR3','TE4','SE3','TR6','T10'/
    data    fami   /'BID','XINT','XINT','BID','XINT','XINT'/
! ----------------------------------------------------------------------
!
!
!-----------------------------------------------------------------------
!   INITIALISATIONS
!-----------------------------------------------------------------------
!
!   ELEMENT DE REFERENCE PARENT : RECUP DE NDIM ET NNOP
    call elref1(elrefp)
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nnop)
    ASSERT(nnop.le.27)
!
!
!   SOUS-ELEMENT DE REFERENCE : RECUP DE NNO, NPG, IVF ET JGANO
    if (.not.iselli(elrefp)) then
        irese=3
    else
        irese=0
    endif
    call elrefe_info(elrefe=elrese(ndim+irese),&
                     fami=fami(ndim+irese),&
                     nno=nno,&
                     npg=npg,&
                     jvf=ivf,&
                     jgano=jgano)
!
    ASSERT(npg.le.15)
!
!   INITIALISATION DES DIMENSIONS DES DDLS X-FEM
    call xteini(nomte, nfh, nfe, singu, ddlc,&
                ibid, ibid, ibid, ibid, ibid,&
                ibid)
!
!   NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
    nbsig = nbsigm()
    ASSERT(nbsig.le.6)
!
!-----------------------------------------------------------------------
!   RECUPERATION DES ENTREES / SORTIE
!-----------------------------------------------------------------------
!
    call jevech('PLONCHA', 'L', jlonch)
    call jevech('PCONTRR', 'L', jsigpg)
!
!   RÉCUPÉRATION DE LA SUBDIVISION DE L'ÉLÉMENT EN NSE SOUS ELEMENT
    nse=zi(jlonch-1+1)
!
!-----------------------------------------------------------------------
!   OPTION SISE_ELNO
!-----------------------------------------------------------------------
!
    if (option .eq. 'SISE_ELNO') then
!
!       RECUPERATION DES ENTREES / SORTIE
        call jevech('PCONTSER', 'E', jout1)
!
!       CALCUL DES CONTRAINTES PAR SOUS-ELEMENTS AUX NOEUDS (SENO)
        call xsseno(nno, nbsig, nse, npg, jgano, jsigpg, zr(jout1))
!
!-----------------------------------------------------------------------
!       OPTION SIEF_ELNO ET SIGM_ELNO
!-----------------------------------------------------------------------
!
    else if ((option.eq.'SIEF_ELNO').or. (option.eq.'SIGM_ELNO')) then
!
!       RECUPERATION DES ENTREES / SORTIE
        call jevech('PCNSETO', 'L', jcnset)
        call jevech('PSIEFNOR', 'E', jout2)
!
!       CALCUL DES CONTRAINTES PAR ELEMENTS AUX NOEUDS (ELNO)
        call xsseno(nno, nbsig, nse, npg, jgano, jsigpg, siseno)
        call xselno(nno, nnop, nbsig, nse, ndim, jcnset, siseno, jout2)
!
!-----------------------------------------------------------------------
!     OPTION NON PREVUE
!-----------------------------------------------------------------------
!
    else
!
        ASSERT(.false.)
!
    endif
!
!
end subroutine
