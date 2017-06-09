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

subroutine jxlir1(ic, caralu)
! person_in_charge: j-pierre.lefebvre at edf.fr
! aslint: disable=W1303
! for the path name
    implicit none
#include "asterf_types.h"
#include "asterc/closdr.h"
#include "asterc/opendr.h"
#include "asterc/readdr.h"
#include "asterfort/codent.h"
#include "asterfort/get_jvbasename.h"
#include "asterfort/utmess.h"
    integer :: ic, caralu(*)
! ----------------------------------------------------------------------
! RELECTURE DU PREMIER ENREGISTREMENT D UNE BASE JEVEUX
!
! IN  IC    : CLASSE ASSOCIEE
! OUT CARALU: CARACTERISTIQUES DE LA BASE
! ----------------------------------------------------------------------
    integer :: n
!-----------------------------------------------------------------------
    integer :: ierr, k
!-----------------------------------------------------------------------
    parameter      ( n = 5 )
    character(len=2) :: dn2
    character(len=5) :: classe
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe    , nomfic(n) , kstout(n) , kstini(n) ,&
     &                 dn2(n)
    character(len=8) :: nombas
    common /kbasje/  nombas(n)
    character(len=128) :: repglo, repvol
    common /banvje/  repglo,repvol
    integer :: lrepgl, lrepvo
    common /balvje/  lrepgl,lrepvo
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
!     ------------------------------------------------------------------
    integer :: npar, np2
    parameter ( npar = 12, np2 = npar+3 )
    integer :: tampon(np2), mode
    aster_logical :: lexist
    character(len=8) :: nom
    character(len=512) :: nom512, valk(2)
! DEB ------------------------------------------------------------------
    ierr = 0
    mode = 1
    if ( kstout(ic) == 'LIBERE' .and. kstini(ic) == 'POURSUIT' ) then
        mode = 0
    endif
    if ( kstini(ic) == 'DEBUT' ) then
        mode = 2
    endif
    nom = nomfic(ic)(1:4)//'.   '
    call get_jvbasename(nomfic(ic)(1:4), 1, nom512)
    inquire (file=nom512,exist=lexist)
    if (.not. lexist) then
        valk(1) = nombas(ic)
        valk(2) = nom512
        call utmess('F', 'JEVEUX_12', nk=2, valk=valk)
    endif
    call opendr(nom512, mode, ierr)
!
!   SUR CRAY L'APPEL A READDR EST EFFECTUE AVEC UNE LONGUEUR EN
!   ENTIER, A MODIFIER LORSQUE L'ON PASSERA AUX ROUTINES C
!
    call readdr(nom512, tampon, np2*lois, 1, ierr)
    if (ierr .ne. 0) then
        call utmess('F', 'JEVEUX_13', sk=nombas(ic))
    endif
    call closdr(nom512, ierr)
    if (ierr .ne. 0) then
        call utmess('F', 'JEVEUX_14', sk=nombas(ic))
    endif
    do k = 1, npar
        caralu(k) = tampon(k+3)
    end do
! FIN ------------------------------------------------------------------
end subroutine
