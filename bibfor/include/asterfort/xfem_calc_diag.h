! COPYRIGHT (C) 1991 - 2013  EDF R&D                WWW.CODE-ASTER.ORG
!
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
#include "asterf_types.h"
!
interface
    subroutine xfem_calc_diag(matass, nonu, neq, deeq, nbnomax, &
                               ino_xfem, is_xfem, nbnoxfem, ieq_loc,&
                               scal, deca, tab_mloc)
        character(len=19) :: matass
        character(len=14) :: nonu
        integer :: neq
        integer :: deeq(*)
        integer :: ino_xfem(nbnomax)
        aster_logical :: is_xfem(nbnomax)
        integer :: nbnomax
        integer :: nbnoxfem
        integer :: ieq_loc(neq)
        integer :: deca
        real(kind=8) :: scal
        real(kind=8) :: tab_mloc(deca*nbnoxfem)
    end subroutine xfem_calc_diag
end interface
