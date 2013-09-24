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
    subroutine mereso(result, modele, mate, carele, fomult,&
                      lischa, itps, partps, numedd, vecass,&
                      assmat, solveu, matass, maprec, base,&
                      compor)
        character(len=8) :: result
        character(len=24) :: modele
        character(len=*) :: mate
        character(len=24) :: carele
        character(len=24) :: fomult
        character(len=19) :: lischa
        integer :: itps
        real(kind=8) :: partps(*)
        character(len=24) :: numedd
        character(len=19) :: vecass
        logical :: assmat
        character(len=19) :: solveu
        character(len=19) :: matass
        character(len=19) :: maprec
        character(len=1) :: base
        character(len=24) :: compor
    end subroutine mereso
end interface
