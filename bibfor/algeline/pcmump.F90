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

subroutine pcmump(matasz, solvez, iretz, new_facto)
    implicit none
#include "jeveux.h"
#include "asterfort/amumph.h"
#include "asterfort/assert.h"
#include "asterfort/crsmsp.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtmchc.h"
    character(len=*) :: matasz, solvez
    integer :: iretz
    aster_logical, intent(out), optional :: new_facto
!-----------------------------------------------------------------------
!
!     CREATION D'UNE MATRICE DE PRECONDITIONNEMENT (PETSC, GCPC)
!     PAR FACTORISATION SIMPLE PRECISION PAR MUMPS
!
!-----------------------------------------------------------------------
! IN  K*  MATASZ    : NOM DE LA MATR_ASSE A PRECONDITIONNER
! IN  K*  SOLVEZ    : NOM DE LA SD SOLVEUR
! OUT  I   IRETZ     : CODE RETOUR (!=0 SI ERREUR)
!----------------------------------------------------------------------
!     VARIABLES LOCALES
!----------------------------------------------------------------------
    integer ::   iterpr, reacpr, pcpiv,  iret
    aster_logical :: new_facto_loc
    complex(kind=8) :: cbid
    character(len=19) :: solveu, matass
    character(len=24) :: precon, solvbd
    character(len=24) :: usersm
    integer, pointer :: slvi(:) => null()
    character(len=24), pointer :: refa(:) => null()
    character(len=24), pointer :: slvk(:) => null()
!----------------------------------------------------------------------
    call jemarq()
!
    matass = matasz
    solveu = solvez
    cbid=dcmplx(0.d0,0.d0)
!
! --  PARAMETRES DU PRECONDITIONNEUR
    call jeveuo(solveu//'.SLVK', 'L', vk24=slvk)
    call jeveuo(solveu//'.SLVI', 'L', vi=slvi)
    precon=slvk(2)
    usersm=slvk(9)
    iterpr=slvi(5)
    reacpr=slvi(6)
    pcpiv =slvi(7)
!
    new_facto_loc = .false.
!
    ASSERT(precon.eq.'LDLT_SP')
    
!
! --  PRISE EN COMPTE DES CHARGEMENTS CINEMATIQUES
! --  SAUF DANS LE CAS OU LE SOLVEUR EST PETSC
! --  CAR DEJA FAIT DANS APETSC
    if (slvk(1) .ne. 'PETSC') then
        call jeveuo(matass//'.REFA', 'L', vk24=refa)
 !       ASSERT(refa(3).ne.'ELIMF')
        if (refa(3) .eq. 'ELIML') call mtmchc(matass, 'ELIMF')
        ASSERT(refa(3).ne.'ELIML')
    endif
!
! --  CREATION DE LA SD SOLVEUR MUMPS SIMPLE PRECISION
! --  (A DETRUIRE A LA SORTIE)
    solvbd=slvk(3)
    call crsmsp(solvbd, matass, pcpiv, usersm)
!
! --  APPEL AU PRECONDITIONNEUR
    iret = 0
    if (iterpr .gt. reacpr .or. iterpr .eq. 0) then
        call amumph('DETR_MAT', solvbd, matass, [0.d0], [cbid],&
                    ' ', 0, iret, .true._1)
        call amumph('PRERES', solvbd, matass, [0.d0], [cbid],&
                    ' ', 0, iret, .true._1)
        new_facto_loc = .true.
    endif
!
    if ( present( new_facto) ) then 
       new_facto = new_facto_loc
    endif 
!
! --  DESTRUCTION DE LA SD SOLVEUR MUMPS SIMPLE PRECISION
    call detrsd('SOLVEUR', solvbd)
!
! --  CODE RETOUR
    iretz = iret
!
    call jedema()
end subroutine
