# frozen_string_literal: true

class RegistersController < ApplicationController
  before_action :set_register, only: [:show, :edit, :update, :destroy]

  # @route GET /books/:book_id/registers (book_registers)
  def index
    @registers = Register.all
  end

  # @route GET /books/:book_id/registers/:id (book_register)
  def show
  end

  # @route GET /books/:book_id/registers/new (new_book_register)
  def new
    @register = Register.new
  end

  # @route GET /books/:book_id/registers/:id/edit (edit_book_register)
  def edit
  end

  # @route POST /books/:book_id/registers (book_registers)
  def create
    @register = Register.new(register_params)

    if @register.save
      redirect_to @register, notice: "Register was successfully created."
    else
      render :new
    end
  end

  # @route PATCH /books/:book_id/registers/:id (book_register)
  # @route PUT /books/:book_id/registers/:id (book_register)
  def update
    if @register.update(register_params)
      redirect_to @register, notice: "Register was successfully updated."
    else
      render :edit
    end
  end

  # @route DELETE /books/:book_id/registers/:id (book_register)
  def destroy
    @register.destroy
    redirect_to registers_url, notice: "Register was successfully destroyed."
  end

  private

  def set_register
    @register = Register.find(params[:id])
  end

  def register_params
    params.fetch(:register, {})
  end
end
