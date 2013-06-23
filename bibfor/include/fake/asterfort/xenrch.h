!
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
interface
    subroutine xenrch(nomo, noma, cnslt, cnsln, cnslj,&
                      cnsen, cnsenr, ndim, fiss, goinop,&
                      lismae, lisnoe)
        character(len=8) :: nomo
        character(len=8) :: noma
        character(len=19) :: cnslt
        character(len=19) :: cnsln
        character(len=19) :: cnslj
        character(len=19) :: cnsen
        character(len=19) :: cnsenr
        integer :: ndim
        character(len=8) :: fiss
        logical :: goinop
        character(len=24) :: lismae
        character(len=24) :: lisnoe
    end subroutine xenrch
end interface
