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

subroutine xlorie(fiss)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=8) :: fiss
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (CREATION DES SD)
!
! LECTURE DONNEES ORIENTATION FOND DE FISSURE - CREATION XCARFO
!
! ----------------------------------------------------------------------
!
!
! OUT FISS   : NOM DE LA SD FISS_XFEM
!                 FISS//'.CARAFOND'
!
!
!
    integer :: ibid, ir, in, ncouch
    real(kind=8) :: rayon
    character(len=16) :: typenr
    character(len=24) :: xcarfo
    integer :: jcaraf
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- CREATION DU VECTEUR DE STOCKAGE
!
    xcarfo = fiss(1:8)//'.CARAFOND'
    call wkvect(xcarfo, 'G V R', 2, jcaraf)
!
! --- REMPLISSAGE DU VECTEUR DE STOCKAGE
!
!     TYPE ENRICHISSEMENT (TOPOLOGIQUE OU GEOMETRIQUE)
    call getvtx(' ', 'TYPE_ENRI_FOND', scal=typenr, nbret=ibid)
    ASSERT(typenr.eq.'TOPOLOGIQUE'.or.typenr.eq.'GEOMETRIQUE')
    if (typenr .eq. 'TOPOLOGIQUE') then
        rayon = 0.d0
        ncouch = 0
    else if (typenr.eq.'GEOMETRIQUE') then
        call getvr8(' ', 'RAYON_ENRI', scal=rayon, nbret=ir)
        call getvis(' ', 'NB_COUCHES', scal=ncouch, nbret=in)
        if (ir .eq. 0) then
            rayon = 0.d0
            if (ncouch .gt. 7) then
                call utmess('A', 'XFEM_5', si=ncouch)
            endif
        else if (ir.eq.1) then
!         ON NE PEUT PAS DEFINIR DE REGLE "EXCLUS" DANS LE CAPY
!         SINON, DANS LE CAS OU ON NE RENSEIGNE RIEN, IL Y A ERREUR
            if (in .eq. 1) then
                call utmess('F', 'XFEM_17')
            endif
            if (rayon .le. 0.d0) then
                call utmess('F', 'XFEM_6')
            endif
            ncouch = 0
        endif
    endif
!
!      WRITE(6,*) 'RAYON  = ',RAYON
!      WRITE(6,*) 'NCOUCH = ',NCOUCH
!
    ASSERT(rayon*ncouch.eq.0.d0)
!
!     ATTENTION, ON NE PEUT PAS TRANSFORMER NCOUCH EN RAYON EQUIVALENT
!     ICI CAR EN CAS DE PROPAGATION AVEC PROPA_XFEM, LE RAYON EQUIVALENT
!     NE SERAIT PAS RE-ACTUALISE. IL FAUT STOCKER RAYON ET NCOUCH ET NE
!     CALCULER LE RAYON EQUIVALENT QU'AU DERNIER MOMENT (XENRCH)
    zr(jcaraf-1+1 ) = rayon
    zr(jcaraf-1+2) = ncouch
!
!
    call jedema()
end subroutine
