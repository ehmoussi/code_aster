!
! COPYRIGHT (C) 1991 - 2016  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine nmfocc(phase      , model     , mate     , nume_dof , list_func_acti,&
                      ds_contact , ds_measure, hval_algo, hval_incr, hval_veelem   ,&
                      hval_veasse, ds_constitutive)
        use NonLin_Datastructure_type
        character(len=10), intent(in) :: phase
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: nume_dof
        integer, intent(in) :: list_func_acti(*)
        type(NL_DS_Contact), intent(in) :: ds_contact
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19), intent(in) :: hval_algo(*)
        character(len=19), intent(in) :: hval_incr(*)
        character(len=19), intent(in) :: hval_veelem(*)
        character(len=19), intent(in) :: hval_veasse(*)
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
    end subroutine nmfocc
end interface
